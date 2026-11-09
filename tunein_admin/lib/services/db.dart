import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models.dart';

/// El usuario que inició sesión (Firebase Auth).
/// Cada usuario tiene su propia Librería, Recientes y Tus Favs.
class CurrentUser {
  static User? get _user => FirebaseAuth.instance.currentUser;

  static String get id => _user!.uid;
  static String get email => _user?.email ?? '';

  /// Nombre visible: el de Google, o la parte del correo antes de la @.
  static String get username {
    final name = _user?.displayName;
    if (name != null && name.isNotEmpty) return name;
    return email.split('@').first;
  }
}

/// Firestore. Estructura:
///   stations/{id}                   emisora
///     posts/{id}/comments/{id}      posts y sus comentarios
///     moments/{id}                  audio moments
///   users/{uid}                     { stationId } si el usuario es emisora
///     favorites/{stationId}         Librería
///     recents/{stationId}           Recientes
///     likes/{itemId}                Tus Favs (copia del post/moment)
class Db {
  static final _fs = FirebaseFirestore.instance;
  static final stations = _fs.collection('stations');
  // Getter (no final): si cambia el usuario, apunta al documento nuevo.
  static DocumentReference<Map<String, dynamic>> get _me =>
      _fs.collection('users').doc(CurrentUser.id);

  static Stream<List<T>> _list<T>(
    Query<Map<String, dynamic>> q,
    T Function(Doc) f,
  ) => q.snapshots().map((s) => s.docs.map(f).toList());

  static Stream<Set<String>> _ids(String sub) => _me
      .collection(sub)
      .snapshots()
      .map((s) => s.docs.map((d) => d.id).toSet());

  // Emisoras
  static Stream<List<Station>> allStations() =>
      _list(stations.orderBy('name'), Station.fromDoc);

  static Stream<String?> myStationId() =>
      _me.snapshots().map((d) => d.data()?['stationId'] as String?);

  static Future<void> createStation(String id, Station s) =>
      (_fs.batch()
            ..set(stations.doc(id), {...s.toMap(), 'ownerUid': CurrentUser.id})
            ..set(_me, {'stationId': id}, SetOptions(merge: true)))
          .commit();

  // Librería y recientes
  static Future<void> setFavorite(String stationId, bool on) {
    final ref = _me.collection('favorites').doc(stationId);
    return on ? ref.set({'at': FieldValue.serverTimestamp()}) : ref.delete();
  }

  static Future<void> addRecent(String stationId) => _me
      .collection('recents')
      .doc(stationId)
      .set({'at': FieldValue.serverTimestamp()});

  // Posts y audio moments
  static CollectionReference<Map<String, dynamic>> items(
    String stationId,
    bool moments,
  ) => stations.doc(stationId).collection(moments ? 'moments' : 'posts');

  static Stream<List<Item>> itemsOf(
    String stationId, {
    required bool moments,
  }) => _list(
    items(stationId, moments).orderBy('createdAt', descending: true),
    Item.fromDoc,
  );

  static Future<void> addItem(Item i) => items(i.stationId, i.isMoment).add({
    ...i.toMap(),
    'likeCount': 0,
    'commentCount': 0,
    'createdAt': FieldValue.serverTimestamp(),
  });

  static Future<void> deleteItem(Item i) =>
      items(i.stationId, i.isMoment).doc(i.id).delete();

  // Likes ("Tus Favs")
  static Stream<List<Item>> likesOf(String stationId) => _list(
    _me.collection('likes').where('stationId', isEqualTo: stationId),
    Item.fromDoc,
  );

  static Future<void> setLike(Item i, bool on) {
    final like = _me.collection('likes').doc(i.id);
    final batch = _fs.batch();
    on ? batch.set(like, i.toMap()) : batch.delete(like);
    batch.update(items(i.stationId, i.isMoment).doc(i.id), {
      'likeCount': FieldValue.increment(on ? 1 : -1),
    });
    return batch.commit();
  }

  // Comentarios
  static Stream<List<Comment>> comments(Item post) => _list(
    items(
      post.stationId,
      false,
    ).doc(post.id).collection('comments').orderBy('createdAt'),
    Comment.fromDoc,
  );

  static Future<void> addComment(Item post, String text) {
    final ref = items(post.stationId, false).doc(post.id);
    return (_fs.batch()
          ..set(ref.collection('comments').doc(), {
            'username': CurrentUser.username,
            'text': text,
            'createdAt': FieldValue.serverTimestamp(),
          })
          ..update(ref, {'commentCount': FieldValue.increment(1)}))
        .commit();
  }
}

/// Datos que usan varias pantallas a la vez, cargados una sola vez.
/// Las pantallas los escuchan con ValueListenableBuilder/ListenableBuilder.
class Store {
  static final stations = ValueNotifier<List<Station>?>(
    null,
  ); // null = cargando
  static final favorites = ValueNotifier<Set<String>>({});
  static final recents = ValueNotifier<List<String>>([]);
  static final liked = ValueNotifier<Set<String>>({});
  static final myStationId = ValueNotifier<String?>(null);
  static final error = ValueNotifier<String?>(null);

  static final List<StreamSubscription<Object?>> _subs = [];

  /// Empieza a escuchar Firestore para el usuario actual.
  static void start() {
    stop(); // por si quedó algo de una sesión anterior
    void fail(Object e) => error.value = '$e';
    _subs.addAll([
      Db.allStations().listen((v) => stations.value = v, onError: fail),
      Db._ids('favorites').listen((v) => favorites.value = v, onError: fail),
      Db._ids('likes').listen((v) => liked.value = v, onError: fail),
      Db.myStationId().listen((v) => myStationId.value = v, onError: fail),
      Db._me
          .collection('recents')
          .orderBy('at', descending: true)
          .limit(12)
          .snapshots()
          .listen(
            (s) => recents.value = s.docs.map((d) => d.id).toList(),
            onError: fail,
          ),
    ]);
  }

  /// Deja de escuchar y limpia los datos (al cerrar sesión).
  static void stop() {
    for (final s in _subs) {
      s.cancel();
    }
    _subs.clear();
    stations.value = null;
    favorites.value = {};
    recents.value = [];
    liked.value = {};
    myStationId.value = null;
    error.value = null;
  }

  static List<Station> get _all => stations.value ?? const [];
  static Station? byId(String id) => _all.where((s) => s.id == id).firstOrNull;
  static List<Station> get favoriteStations =>
      _all.where((s) => favorites.value.contains(s.id)).toList();
  static List<Station> get recentStations =>
      recents.value.map(byId).whereType<Station>().toList();
}

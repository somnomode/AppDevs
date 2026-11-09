import 'package:cloud_firestore/cloud_firestore.dart';

/// Datos de la app. Cada clase sabe leerse desde un documento de Firestore.
typedef Doc = DocumentSnapshot<Map<String, dynamic>>;

Map<String, dynamic> _data(Doc d) => d.data() ?? const {};
String _s(Map m, String k) => m[k] as String? ?? '';
int _i(Map m, String k) => (m[k] as num?)?.toInt() ?? 0;

/// Categorías = chips del Home.
const categories = {
  'radio': 'Radio',
  'deporte': 'Deporte',
  'podcast': 'Podcast',
};

/// Emisora — `stations/{id}`. La transmisión se simula con `audioUrl`.
class Station {
  const Station({
    required this.id,
    required this.name,
    this.genre = '',
    this.category = 'radio',
    this.location = '',
    this.frequency = '',
    this.description = '',
    this.imageUrl = '',
    this.audioUrl = '',
    this.lat,
    this.lng,
  });

  final String id, name, genre, category, location, frequency, description;
  final String imageUrl, audioUrl;
  final double? lat, lng;

  bool get hasLocation => lat != null && lng != null;
  String get subtitle =>
      [genre, location].where((s) => s.isNotEmpty).join(' · ');

  factory Station.fromDoc(Doc doc) {
    final d = _data(doc);
    return Station(
      id: doc.id,
      name: _s(d, 'name'),
      genre: _s(d, 'genre'),
      category: _s(d, 'category'),
      location: _s(d, 'location'),
      frequency: _s(d, 'frequency'),
      description: _s(d, 'description'),
      imageUrl: _s(d, 'imageUrl'),
      audioUrl: _s(d, 'audioUrl'),
      lat: (d['lat'] as num?)?.toDouble(),
      lng: (d['lng'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'genre': genre,
    'category': category,
    'location': location,
    'frequency': frequency,
    'description': description,
    'imageUrl': imageUrl,
    'audioUrl': audioUrl,
    'lat': lat,
    'lng': lng,
  };
}

/// Lo que publica una emisora en Comunidad: un post (imagen + texto)
/// o un audio moment (clip). Mismo modelo para los dos.
/// `stations/{stationId}/posts/{id}` o `stations/{stationId}/moments/{id}`
class Item {
  const Item({
    required this.id,
    required this.stationId,
    required this.isMoment,
    required this.title,
    this.summary = '',
    this.imageUrl = '',
    this.audioUrl = '',
    this.durationMs,
    this.likeCount = 0,
    this.commentCount = 0,
  });

  final String id, stationId, title, summary, imageUrl, audioUrl;
  final bool isMoment;
  final int? durationMs;
  final int likeCount, commentCount;

  String get collection => isMoment ? 'moments' : 'posts';
  Duration? get duration =>
      durationMs == null ? null : Duration(milliseconds: durationMs!);

  /// Lee un post/moment, o un like guardado en `users/{uid}/likes`.
  factory Item.fromDoc(Doc doc) {
    final d = _data(doc);
    return Item(
      id: doc.id,
      stationId: d['stationId'] as String? ?? doc.reference.parent.parent!.id,
      isMoment: d['type'] == 'moment' || doc.reference.parent.id == 'moments',
      title: _s(d, 'title'),
      summary: _s(d, 'summary'),
      imageUrl: _s(d, 'imageUrl'),
      audioUrl: _s(d, 'audioUrl'),
      durationMs: (d['durationMs'] as num?)?.toInt(),
      likeCount: _i(d, 'likeCount'),
      commentCount: _i(d, 'commentCount'),
    );
  }

  Map<String, dynamic> toMap() => {
    'stationId': stationId,
    'type': isMoment ? 'moment' : 'post',
    'title': title,
    'summary': summary,
    'imageUrl': imageUrl,
    'audioUrl': audioUrl,
    'durationMs': durationMs,
  };
}

/// Comentario — `stations/{s}/posts/{p}/comments/{id}`
class Comment {
  const Comment(this.username, this.text);
  final String username, text;

  factory Comment.fromDoc(Doc doc) {
    final d = _data(doc);
    return Comment(_s(d, 'username'), _s(d, 'text'));
  }
}

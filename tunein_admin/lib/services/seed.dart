import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'db.dart';

/// Las 8 emisoras de TuneIn (3 radios, 3 deportes, 2 podcasts).
/// Se cargan desde Perfil → "Cargar datos demo".
///
/// Portadas y audios viven en Firebase Storage:
///   covers/{id}.jpg   →  ej. covers/iced-out.jpg
///   audio/{id}.mp3    →  ej. audio/iced-out.mp3 (o .m4a, .mp4, .wav…)
/// Si un archivo todavía no está subido, se usa uno de reemplazo
/// (imagen de picsum.photos / MP3 libre de SoundHelix), así la app
/// funciona igual. Al subir el archivo real, basta con volver a cargar.
const _stations = [
  // id, nombre, categoría, género, ciudad, frecuencia, lat, lng, descripción
  [
    'off-the-record',
    'Off the Record',
    'radio',
    'Rock',
    'Santiago, Chile',
    '88.5 FM',
    -33.4489,
    -70.6693,
    'Rock clásico: oldies but goodies, las 24 horas.',
  ],
  [
    'bad-decisions-fm',
    'Bad Decisions FM',
    'radio',
    'Pop',
    'Valparaíso, Chile',
    '101.3 FM',
    -33.0472,
    -71.6127,
    'Los hits pop del momento.',
  ],
  [
    'ritmo-latino',
    'Ritmo Latino',
    'radio',
    'Latino',
    'Bogotá, Colombia',
    '96.9 FM',
    4.7110,
    -74.0721,
    'Reggaetón, salsa y cumbia sin parar.',
  ],
  [
    'pulso-futbol',
    'Pulso Fútbol',
    'deporte',
    'Fútbol',
    'Santiago, Chile',
    '1180 AM',
    -33.4645,
    -70.6109,
    'Fútbol chileno e internacional en vivo.',
  ],
  [
    'iced-out',
    'Iced Out',
    'deporte',
    'Hockey',
    'Denver, Colorado, EE.UU.',
    '1040 AM',
    39.7392,
    -104.9903,
    'Live from the Rink: todo el hockey sobre hielo.',
  ],
  [
    'mma-amazons',
    'MMA Amazons',
    'deporte',
    'MMA',
    'Sídney, Australia',
    '920 AM',
    -33.8688,
    151.2093,
    'Artes marciales mixtas femeninas: peleas, análisis y entrevistas.',
  ],
  [
    'expediente-rojo',
    'Expediente Rojo',
    'podcast',
    'True crime',
    'Buenos Aires, Argentina',
    '',
    -34.6037,
    -58.3816,
    'Casos reales, contados paso a paso.',
  ],
  [
    'comedy',
    'The Liban & Fu Show',
    'podcast',
    'Comedia',
    'Concepción, Chile',
    '',
    -36.8270,
    -73.0503,
    'Dos amigos, cero filtro.',
  ],
];

const _posts = [
  ['Detrás de cámaras', 'Así se ve la cabina en plena transmisión.'],
  ['Nuevo horario', 'Desde el lunes partimos a las 7:00.'],
];

const _comments = [
  ['camila.r', '¡Los escucho todas las mañanas!'],
  ['benja_94', 'Qué buen programa el de hoy.'],
];

/// Lista una carpeta de Storage y devuelve {nombre sin extensión: ref}.
/// Así "audio/iced-out.mp3", "audio/iced-out.m4a" o "audio/iced-out.mp4"
/// sirven igual: lo que importa es el nombre, no la extensión.
Future<Map<String, Reference>> _folder(String path) async {
  try {
    final result = await FirebaseStorage.instance.ref(path).listAll();
    return {
      for (final r in result.items)
        r.name.contains('.')
                ? r.name.substring(0, r.name.lastIndexOf('.')).toLowerCase()
                : r.name.toLowerCase():
            r,
    };
  } catch (_) {
    return {}; // carpeta vacía o Storage no disponible
  }
}

/// URL de descarga del archivo [id] en [files], o null si no existe.
Future<String?> _url(Map<String, Reference> files, String id) async {
  try {
    return await files[id]?.getDownloadURL();
  } catch (_) {
    return null;
  }
}

/// Devuelve un resumen, ej: "8 emisoras · 8/8 portadas · 8/8 audios".
Future<String> seedDemoData() async {
  final fs = FirebaseFirestore.instance;
  final now = DateTime.now();
  String placeholderImg(String seed) =>
      'https://picsum.photos/seed/$seed/600/600';
  String placeholderMp3(int n) =>
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-$n.mp3';

  // 1. Borrar emisoras que ya no están en la lista (las 12 demo antiguas).
  final ids = {for (final s in _stations) s[0] as String};
  final old = await Db.stations.get();
  final batch = fs.batch();
  for (final doc in old.docs) {
    if (!ids.contains(doc.id)) batch.delete(doc.reference);
  }

  // 2. Ver qué portadas y audios hay subidos en Storage.
  final covers = await _folder('covers');
  final audios = await _folder('audio');

  // 3. Crear/actualizar las 8 emisoras con sus posts y audio moments.
  var song = 1;
  for (final s in _stations) {
    final id = s[0] as String;
    final ref = Db.stations.doc(id);
    final cover = await _url(covers, id) ?? placeholderImg(id);
    final audio = await _url(audios, id) ?? placeholderMp3(song);

    batch.set(ref, {
      'name': s[1],
      'category': s[2],
      'genre': s[3],
      'location': s[4],
      'frequency': s[5],
      'lat': s[6],
      'lng': s[7],
      'description': s[8],
      'imageUrl': cover,
      'audioUrl': audio,
      'ownerUid': CurrentUser.id,
    });

    for (var i = 0; i < _posts.length; i++) {
      final post = ref.collection('posts').doc('$id-post-$i');
      batch.set(post, {
        'stationId': id,
        'title': _posts[i][0],
        'summary': _posts[i][1],
        'imageUrl': i == 0 ? cover : placeholderImg('$id-post-$i'),
        'likeCount': 0,
        'commentCount': i == 0 ? _comments.length : 0,
        'createdAt': Timestamp.fromDate(now.subtract(Duration(days: i))),
      });
      if (i == 0) {
        for (var c = 0; c < _comments.length; c++) {
          batch.set(post.collection('comments').doc('c$c'), {
            'username': _comments[c][0],
            'text': _comments[c][1],
            'createdAt': Timestamp.fromDate(now),
          });
        }
      }
    }

    // Audio moments: por ahora usan el mismo audio de la emisora.
    for (var i = 1; i <= 2; i++) {
      batch.set(ref.collection('moments').doc('$id-moment-$i'), {
        'stationId': id,
        'title': '${s[1]} · Momento $i',
        'audioUrl': audio,
        'imageUrl': cover,
        'likeCount': 0,
        'createdAt': Timestamp.fromDate(now.subtract(Duration(days: i))),
      });
    }
    song++;
  }

  await batch.commit();
  final n = _stations.length;
  final c = ids.where(covers.containsKey).length;
  final a = ids.where(audios.containsKey).length;
  return '$n emisoras · $c/$n portadas · $a/$n audios desde Storage';
}

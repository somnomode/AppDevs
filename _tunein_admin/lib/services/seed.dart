import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'db.dart';

/// Las 34 emisoras de TuneIn, repartidas por el mundo:
/// 24 radios (Rock, Pop, Latino, Reggaetón, Noticias), 3 deportes y
/// 7 podcasts.
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
  [
    'electric-riot',
    'Electric Riot',
    'radio',
    'Rock',
    'Tokio, Japón',
    '89.7 FM',
    35.6762,
    139.6503,
    'Hard rock y glam a todo volumen.',
  ],
  [
    'rock-legends',
    'Rock Legends',
    'radio',
    'Rock',
    'Londres, Reino Unido',
    '97.1 FM',
    51.5074,
    -0.1278,
    'Las leyendas del rock, de los 60 a hoy.',
  ],
  [
    'punk-rebellion',
    'Punk Rebellion',
    'radio',
    'Rock',
    'Berlín, Alemania',
    '104.5 FM',
    52.52,
    13.405,
    'Punk rápido, ruidoso y sin pedir permiso.',
  ],
  [
    'psychadelic-dreams',
    'Psychedelic Dreams',
    'radio',
    'Rock',
    'Goa, India',
    '92.3 FM',
    15.4909,
    73.8278,
    'Rock psicodélico para viajar sin moverse.',
  ],
  [
    'grunge-soul',
    'Grunge Soul',
    'radio',
    'Rock',
    'Seattle, EE.UU.',
    '99.9 FM',
    47.6062,
    -122.3321,
    'Grunge y alternativo desde su ciudad natal.',
  ],
  [
    'glitter-bomb',
    'Glitter Bomb',
    'radio',
    'Pop',
    'Seúl, Corea del Sur',
    '95.5 FM',
    37.5665,
    126.978,
    'Pop brillante, coreografías y brillos.',
  ],
  [
    'girly-pop',
    'Girly Pop',
    'radio',
    'Pop',
    'París, Francia',
    '102.7 FM',
    48.8566,
    2.3522,
    'Las divas del pop, todo el día.',
  ],
  [
    'retro-pop',
    'Retro Pop',
    'radio',
    'Pop',
    'Estocolmo, Suecia',
    '90.1 FM',
    59.3293,
    18.0686,
    'Synth-pop y clásicos de los 80.',
  ],
  [
    'mirro-radio',
    'MirroRadio',
    'radio',
    'Pop',
    'Dubái, Emiratos Árabes',
    '103.9 FM',
    25.2048,
    55.2708,
    'Future pop y electrónica.',
  ],
  [
    'lentejuelas',
    'Lentejuelas',
    'radio',
    'Pop',
    'Río de Janeiro, Brasil',
    '94.3 FM',
    -22.9068,
    -43.1729,
    'Pop latino con ritmo de carnaval.',
  ],
  [
    'reggias',
    'Reggias',
    'radio',
    'Reggaetón',
    'Medellín, Colombia',
    '100.5 FM',
    6.2442,
    -75.5812,
    'Lo más nuevo del reggaetón.',
  ],
  [
    'cloudy-reggea',
    'Cloudy Reggea',
    'radio',
    'Reggaetón',
    'Ciudad de México, México',
    '98.5 FM',
    19.4326,
    -99.1332,
    'Reggaetón chill para días nublados.',
  ],
  [
    'salio-el-sol',
    'Salió el Sol',
    'radio',
    'Reggaetón',
    'San Juan, Puerto Rico',
    '105.1 FM',
    18.4655,
    -66.1057,
    'Reggaetón clásico, los que nunca pasan.',
  ],
  [
    'vibraz',
    'Vibraz',
    'radio',
    'Reggaetón',
    'Madrid, España',
    '91.7 FM',
    40.4168,
    -3.7038,
    'Urbano y reggaetón con buena vibra.',
  ],
  [
    'explicitos',
    'Explícitos',
    'radio',
    'Reggaetón',
    'Miami, EE.UU.',
    '106.3 FM',
    25.7617,
    -80.1918,
    'Perreo sin censura. Contenido explícito.',
  ],
  [
    'mornings',
    'Mornings',
    'podcast',
    'Motivación',
    'Ciudad del Cabo, Sudáfrica',
    '',
    -33.9249,
    18.4241,
    'Motivación para empezar bien el día.',
  ],
  [
    'tonight-show',
    'The Tonight Show',
    'podcast',
    'Hollywood',
    'Nueva York, EE.UU.',
    '',
    40.7128,
    -74.006,
    'Entrevistas y humor con las estrellas.',
  ],
  [
    'vogue',
    'Vogue',
    'podcast',
    'Hollywood',
    'Los Ángeles, EE.UU.',
    '',
    34.0522,
    -118.2437,
    'Moda, celebridades y alfombras rojas.',
  ],
  [
    'mtv',
    'MTV News',
    'podcast',
    'Hollywood',
    'Toronto, Canadá',
    '',
    43.6532,
    -79.3832,
    'Noticias de música y cultura pop.',
  ],
  [
    'out-there',
    'Out There',
    'podcast',
    'Aire libre',
    'Queenstown, Nueva Zelanda',
    '',
    -45.0312,
    168.6626,
    'Historias de montaña, viajes y naturaleza.',
  ],
  [
    'ai-vs-humans',
    'AI vs Humans',
    'radio',
    'Noticias',
    'San Francisco, EE.UU.',
    '810 AM',
    37.7749,
    -122.4194,
    'Tecnología e inteligencia artificial: el debate del momento.',
  ],
  [
    'flash-news',
    'Flash News',
    'radio',
    'Noticias',
    'El Cairo, Egipto',
    '1020 AM',
    30.0444,
    31.2357,
    'Noticias de última hora, cada hora.',
  ],
  [
    'fresh-updates',
    'Fresh Updates',
    'radio',
    'Noticias',
    'Singapur',
    '950 AM',
    1.3521,
    103.8198,
    'Las noticias del día, cortas y al grano.',
  ],
  [
    'its-the-news',
    'It’s the News',
    'radio',
    'Noticias',
    'Lima, Perú',
    '1160 AM',
    -12.0464,
    -77.0428,
    'Actualidad, política y sociedad.',
  ],
  [
    'tv5',
    'TV5 News',
    'radio',
    'Noticias',
    'Hyderabad, India',
    '870 AM',
    17.385,
    78.4867,
    'Noticias de India y el mundo.',
  ],
  [
    'world-news',
    'World News',
    'radio',
    'Noticias',
    'Nairobi, Kenia',
    '1340 AM',
    -1.2921,
    36.8219,
    'Lo que pasa en el mundo, en vivo.',
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

  // 1. Borrar emisoras demo que ya no están en la lista.
  final ids = {for (final s in _stations) s[0] as String};
  final old = await Db.stations.get();
  final batch = fs.batch();
  for (final doc in old.docs) {
    // Solo las marcadas como demo: la emisora creada en Studio no se toca.
    if (!ids.contains(doc.id) && doc.data()['demo'] == true) {
      batch.delete(doc.reference);
    }
  }

  // 2. Ver qué portadas y audios hay subidos en Storage.
  final covers = await _folder('covers');
  final audios = await _folder('audio');

  // 3. Crear/actualizar las emisoras con sus posts y audio moments.
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
      'demo': true, // emisora de ejemplo (la carga este botón)
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

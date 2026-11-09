import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'db.dart';

/// Elegir archivos del teléfono y subirlos a Cloud Storage.
class Storage {
  /// Abre el selector. `withData: true` = cargar el archivo para subirlo.
  static Future<PlatformFile?> pick({required bool audio}) async {
    final r = await FilePicker.platform.pickFiles(
      type: audio ? FileType.audio : FileType.image,
      withData: true,
    );
    return r?.files.single;
  }

  /// Sube [file] a `stations/{stationId}/...` y devuelve su URL pública.
  static Future<String> upload(PlatformFile file, String stationId) async {
    final ext = (file.extension ?? 'bin').toLowerCase();
    final name =
        '${DateTime.now().millisecondsSinceEpoch}_${CurrentUser.id}.$ext';
    final ref = FirebaseStorage.instance.ref('stations/$stationId/$name');
    await ref.putData(file.bytes!, SettableMetadata(contentType: _mime[ext]));
    return ref.getDownloadURL();
  }

  static const _mime = {
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'png': 'image/png',
    'webp': 'image/webp',
    'mp3': 'audio/mpeg',
    'm4a': 'audio/mp4',
    'wav': 'audio/wav',
    'ogg': 'audio/ogg',
  };
}

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

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
  static Future<String> upload(PlatformFile file, String stationId) =>
      _put(file.bytes!, (file.extension ?? 'bin').toLowerCase(), stationId);

  /// Elegir una imagen de la galería con image_picker (código del profe).
  /// Devuelve los bytes de la imagen, o null si el usuario canceló.
  static Future<Uint8List?> pickImageFromGallery() async {
    final foto = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80, // la comprime (queda en JPG)
      maxWidth: 1200,
    );
    return foto?.readAsBytes();
  }

  /// Sube una imagen elegida con [pickImageFromGallery].
  static Future<String> uploadImage(Uint8List bytes, String stationId) =>
      _put(bytes, 'jpg', stationId);

  static Future<String> _put(
    Uint8List bytes,
    String ext,
    String stationId,
  ) async {
    final name =
        '${DateTime.now().millisecondsSinceEpoch}_${CurrentUser.id}.$ext';
    final ref = FirebaseStorage.instance.ref('stations/$stationId/$name');
    await ref.putData(bytes, SettableMetadata(contentType: _mime[ext]));
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

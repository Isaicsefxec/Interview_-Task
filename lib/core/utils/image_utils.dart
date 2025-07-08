import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'platform_utils.dart';

class ImageUtils {
  static Future<Uint8List?> pickImage({bool fromGallery = false}) async {
    final picker = ImagePicker();
    final ImageSource source = fromGallery ? ImageSource.gallery : ImageSource.camera;

    try {
      final XFile? file = await picker.pickImage(source: source);
      return await file?.readAsBytes();
    } catch (_) {
      return null;
    }
  }
}

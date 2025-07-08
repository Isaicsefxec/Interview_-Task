import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:universal_html/html.dart' as html;
import 'package:logger/logger.dart';

final logger = Logger();

class ImageService {
  final ImagePicker _picker = ImagePicker();
  CameraController? _webCameraController;
  XFile? _lastCaptured;

  Future<XFile?> pickImage({
    required BuildContext context,
    required ImageSource source,
    double maxWidth = 1600,
  }) async {
    if (kIsWeb) {
      if (source == ImageSource.camera) {
        return await _openWebCamera(context);
      } else {
        return await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: maxWidth,
        );
      }
    } else {
      return await _picker.pickImage(
        source: source,
        maxWidth: maxWidth,
        preferredCameraDevice: CameraDevice.rear,
      );
    }
  }

  Future<bool> requestWebCamPermission() async {
    try {
      final permissionStatus = await html.window.navigator.permissions
          ?.query({'name': 'camera'}) as html.PermissionStatus?;

      if (permissionStatus == null) {
        logger.w('Camera permission status is null');
        return false;
      }

      logger.i('Camera permission state: ${permissionStatus.state}');

      if (permissionStatus.state == 'granted') {
        return true;
      }

      if (permissionStatus.state == 'prompt') {
        final input = html.FileUploadInputElement();
        input.accept = 'image/*';
        input.setAttribute('capture', 'environment');
        input.click(); // Triggers browser prompt
        logger.i('Camera permission prompt triggered via file input.');
        return true;
      }

      logger.w('Camera permission denied or not allowed');
      return false;
    } catch (e, stack) {
      logger.e('Camera permission check failed', error: e, stackTrace: stack);
      return false;
    }
  }

  Future<XFile?> _openWebCamera(BuildContext context) async {
    if (kIsWeb) {
      // Use HTML input for web camera access
      final input = html.FileUploadInputElement();
      input.accept = 'image/*';
      input.setAttribute('capture', 'environment');
      input.click();

      final completer = Completer<XFile?>();
      input.onChange.listen((event) {
        final file = input.files?.first;
        if (file != null) {
          final reader = html.FileReader();
          reader.readAsDataUrl(file);
          reader.onLoadEnd.listen((event) {
            final result = reader.result as String;
            completer.complete(XFile(result));
          });
        } else {
          completer.complete(null);
        }
      });

      return completer.future;
    }

    // Native platform handling (if needed)
    final cameras = await availableCameras();
    final camera = cameras.firstWhere(
          (cam) => cam.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _webCameraController = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _webCameraController!.initialize();

    _lastCaptured = null;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: _webCameraController!.value.aspectRatio,
              child: CameraPreview(_webCameraController!),
            ),
            ElevatedButton(
              onPressed: () async {
                final image = await _webCameraController!.takePicture();
                _lastCaptured = image;
                Navigator.of(context).pop();
              },
              child: const Text("📸 Capture"),
            ),
          ],
        ),
      ),
    );

    await _webCameraController!.dispose();
    return _lastCaptured;
  }
  ImageProvider getPreviewProvider(XFile file) =>
      kIsWeb ? NetworkImage(file.path) : FileImage(File(file.path));

  bool get isWeb => kIsWeb;
}

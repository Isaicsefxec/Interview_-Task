import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/image_service.dart';

class ImagePickerHelper {
  final ImageService imageService = ImageService();

  Future<XFile?> pickImage(BuildContext context, ImageSource source) async {
    try {
      // If web and using camera, explicitly request permission
      if (imageService.isWeb && source == ImageSource.camera) {
        final granted = await imageService.requestWebCamPermission();
        if (!granted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Camera permission denied')),
          );
          return null;
        }
      }

      return await imageService.pickImage(source: source, context: context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image error: $e')),
      );
      return null;
    }
  }

  void showPickSheet({
    required BuildContext context,
    required bool isWeb,
    required void Function(ImageSource source) onPick,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(24)),
        child: SizedBox(
          height: 140,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _PickOption(
                icon: Icons.camera_alt,
                label: isWeb ? 'Webcam' : 'Camera',
                onTap: () {
                  Navigator.pop(context);
                  onPick(ImageSource.camera);
                },
              ),
              _PickOption(
                icon: Icons.photo_library,
                label: 'Gallery',
                onTap: () {
                  Navigator.pop(context);
                  onPick(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showPreviewSheet({
    required BuildContext context,
    required XFile tempImage,
    required VoidCallback onAdd,
    required VoidCallback onRetake,
  }) {
    final previewProvider = imageService.getPreviewProvider(tempImage);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(24)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 350),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image(
                image: previewProvider,
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: onAdd,
                    icon: const Icon(Icons.check),
                    label: const Text('Add'),
                  ),
                  OutlinedButton.icon(
                    onPressed: onRetake,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retake'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PickOption extends StatelessWidget {
  const _PickOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      InkWell(
        onTap: onTap,
        child: CircleAvatar(radius: 30, child: Icon(icon, size: 28)),
      ),
      const SizedBox(height: 8),
      Text(label),
    ],
  );
}

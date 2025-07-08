import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../utils/image_utils.dart';
import 'app_button.dart';
import 'app_text.dart';

class ImagePickerWidget extends StatefulWidget {
  final void Function(Uint8List imageBytes)? onImagePicked;

  const ImagePickerWidget({super.key, this.onImagePicked});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  Uint8List? _imageBytes;

  Future<void> _pickImage() async {
    final image = await ImageUtils.pickImage();
    if (image != null) {
      setState(() => _imageBytes = image);
      widget.onImagePicked?.call(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _imageBytes != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.memory(
            _imageBytes!,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
        )
            : Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: const Icon(Icons.image, size: 60, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        AppButton(
          label: _imageBytes == null ? 'Pick Image' : 'Pick Another',
          onPressed: _pickImage,
        ),
      ],
    );
  }
}

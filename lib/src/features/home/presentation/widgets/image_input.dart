import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as syspath;

class ImageInput extends StatefulWidget {
  final void Function(File) onSelectImage;

  const ImageInput({super.key, required this.onSelectImage});

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  _takePicture() async {
    final ImagePicker picker = ImagePicker();
    XFile? imageFile =
        await picker.pickImage(source: ImageSource.camera, maxWidth: 600);

    if (imageFile != null) {
      setState(() {
        _storedImage = File(imageFile.path);
      });

      final appDir = await syspath.getApplicationDocumentsDirectory();
      final fileExt = _storedImage!.path.split('.').last;
      final relativePath = '/${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      String newPath = '${appDir.path}$relativePath';
      final savedImage = await _storedImage!.copy(newPath);

      widget.onSelectImage(savedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 180,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: _storedImage != null
              ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                    _storedImage!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
              )
              : const Text('No image'),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: TextButton.icon(
            onPressed: _takePicture,
            icon: const Icon(Icons.camera),
            label: const Text('Take a pick'),
          ),
        ),
      ],
    );
  }
}

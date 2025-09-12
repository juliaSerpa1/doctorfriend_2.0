import 'dart:io';

import 'package:doctorfriend/components/app_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

enum FileType {
  image,
  video,
  pdf,
}

class FileInput extends StatefulWidget {
  final Function(File) onSelectImage;
  final String? selectedImage;
  final bool isCircular;
  final FileType fileType;
  const FileInput(
    this.onSelectImage, {
    super.key,
    this.selectedImage,
    this.isCircular = false,
    this.fileType = FileType.image,
  });

  @override
  State<FileInput> createState() => _FileInputState();
}

class _FileInputState extends State<FileInput> {
  File? _storedImage;

  @override
  initState() {
    super.initState();
    final String? selectedImage = widget.selectedImage;
    if (selectedImage != null) {
      _storedImage = selectedImage.trim() != "" ? File(selectedImage) : null;
    }
  }

  _takePicture() async {
    final ImagePicker picker = ImagePicker();
    XFile? imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );
    if (imageFile == null) return;

    setState(() {
      _storedImage = File(imageFile.path);
    });

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    String fileName = path.basename(_storedImage!.path);
    final savedImage = await _storedImage!.copy(
      '${appDir.path}/$fileName',
    );
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    final fileType = widget.fileType;
    final isCircular = widget.isCircular;
    return InkWell(
      onTap: _takePicture,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: isCircular ? null : Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: isCircular
            ? AppImage(
                imageUrl: _storedImage?.path,
                isCircular: isCircular,
              )
            : Icon(
                fileType == FileType.image
                    ? Icons.add_a_photo
                    : Icons.note_add_outlined,
                size: 40,
                color: Colors.white,
              ),
      ),
    );
  }
}

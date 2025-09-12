import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:doctorfriend/models/upload_stream.dart';
import 'package:doctorfriend/utils/firebase/firebase_storage_util.dart';

class FileViewUpload extends StatefulWidget {
  final File? file;
  final Widget child;
  final Function(Future<String?> Function(String, String?)) addFileToUpload;
  const FileViewUpload({
    super.key,
    this.file,
    required this.child,
    required this.addFileToUpload,
  });

  @override
  State<FileViewUpload> createState() => _FileViewUploadState();
}

class _FileViewUploadState extends State<FileViewUpload> {
  bool _started = false;
  bool _paused = false;
  bool _error = false;
  bool _canceled = false;
  bool _finished = false;
  double _progress = 0.0;

  _handleChangeState(UploadStream uploadStream) {
    setState(() {
      _paused = uploadStream.paused;
      _error = uploadStream.error;
      _canceled = uploadStream.canceled;
      _progress = uploadStream.progress;
      _finished = uploadStream.finished;
    });
  }

  Future<String?> _filesUpload(String table, String? fileName) async {
    final file = widget.file;
    if (file == null) return null;
    setState(() {
      _started = true;
    });
    fileName ??= file.path.split('/').last.split('.').first;
    String randomNumber = Random().nextInt(10000).toString();

    UploadStream uploadStream = await FirebaseStorageUtil.uploadFile(
        table: table, file: file, fileName: "$fileName-$randomNumber");
    uploadStream.listen(sateChanged: () => _handleChangeState(uploadStream));
    await uploadStream.awaitFilishe();
    return uploadStream.downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    const double maxWidth = 88.0;
    const double maxHeight = 85.0;

    final File? file = widget.file;
    final child = widget.child;

    if (file == null) {
      return Container(
        margin: const EdgeInsets.all(2),
        constraints:
            const BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
        child: child,
      );
    }

    widget.addFileToUpload(_filesUpload);

    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.all(2),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Stack(
        children: [
          child,
          if (_started)
            Positioned(
              left: 0,
              top: 0,
              width: maxWidth,
              height: maxHeight,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.6),
                ),
                alignment: Alignment.center,
                child: _canceled || _error
                    ? Icon(
                        Icons.file_upload_off,
                        color: colorScheme.error,
                        size: 35,
                      )
                    : _paused
                        ? Icon(
                            Icons.pause,
                            color: colorScheme.tertiaryContainer,
                            size: 35,
                          )
                        : _finished
                            ? Icon(
                                Icons.check,
                                color: colorScheme.tertiaryContainer,
                                size: 35,
                              )
                            : Text(
                                "${_progress.floor().toString()}%",
                                style: TextStyle(
                                  color: colorScheme.onPrimary,
                                ),
                              ),
              ),
            ),
        ],
      ),
    );
  }
}

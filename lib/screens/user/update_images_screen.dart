import 'dart:io';

import 'package:doctorfriend/exeption/firestore_exception.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/services/users/users_service.dart';
import 'package:doctorfriend/utils/firebase/firebase_storage_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:doctorfriend/components/app_image.dart';
import 'package:doctorfriend/components/callback.dart';
import 'package:doctorfriend/components/file_view_upload.dart';
import 'package:doctorfriend/components/file_input.dart';
import 'package:doctorfriend/components/loading_indicator.dart';
import 'package:doctorfriend/exeption/handle_exception.dart';
import 'package:doctorfriend/utils/firebase/firebase_tables_util.dart';

class UpdateUserImagesScreen extends StatefulWidget {
  final List<String> images;
  const UpdateUserImagesScreen({
    super.key,
    required this.images,
  });

  @override
  State<UpdateUserImagesScreen> createState() => _UpdateUserImagesScreenState();
}

class _UpdateUserImagesScreenState extends State<UpdateUserImagesScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<File> _files = [];
  final List<String> _filesSaved = [];
  final List<String> _filesDeleted = [];
  final _lang = Translations.currentLocale.languageCode;
  //armazena a função que sera criada no momento da seleção de arquivo e so sera chamada quando salvar para visualização do upload
  final List<Future<String?> Function(String, String)> _filesUpload = [];
  bool _loading = false;

  _addFile(File file) {
    setState(() {
      _files.add(file);
    });
  }

  _removeFiles(List<int> indexs) {
    final List<File> files = [];
    for (int i = 0; i < _files.length; i++) {
      bool remove = false;
      for (int index in indexs) {
        if (i == index) {
          remove = true;
        }
      }

      if (!remove) {
        files.add(_files[i]);
      }
    }
    _files.clear();
    setState(() {
      _files.addAll(files);
    });
  }

  _removeFilesSaved(List<int> indexs) async {
    final List<String> files = [];
    final List<String> deletar = [];
    setState(() {
      _loading = true;
    });
    for (int i = 0; i < _filesSaved.length; i++) {
      bool remove = false;
      for (int index in indexs) {
        if (i == index) {
          remove = true;
        }
      }

      if (!remove) {
        files.add(_filesSaved[i]);
      } else {
        deletar.add(_filesSaved[i]);
      }
    }

    await Future.forEach(deletar, (element) async {
      try {
        // await _productsService.deleteImage(
        //   id: widget.product!.id,
        //   url: element,
        // );
        // _filesSaved
        _filesDeleted.add(element);
      } on HandleException catch (error) {
        Callback.snackBar(context, title: error.message);
      } catch (error) {
        Callback.snackBar(context);
      }
    });
    _filesSaved.clear();
    setState(() {
      _loading = false;
      _filesSaved.addAll(files);
    });
  }

  void _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();
    setState(() => _loading = true);
    try {
      final AppUser user = AuthService().currentUser!;
      final List<String> images = [];
      images.addAll(_filesSaved);
      final filesUpload = [..._filesUpload];
      final table = "${FirebaseTablesUtil.userImages}/${user.id}";
      await Future.forEach(filesUpload, (fileUpload) async {
        final String? dowloadUrl = await fileUpload(
          table,
          "${user.id}-galery",
        );
        if (dowloadUrl != null) {
          images.add(dowloadUrl);
        }
      });

      // images.addAll(_filesSaved);
      try {
        for (final url in _filesDeleted) {
          await FirebaseStorageUtil.deleteFile(
            table: table,
            url: url,
            lang: _lang,
          );
        }
      } catch (e) {}

      await UsersService().updateUserGalery(
        userId: user.id,
        galery: images,
      );

      Callback.snackBar(context, error: false);
      context.pop();
    } on FirestoreException catch (error) {
      Callback.snackBar(context, title: error.message);
    } catch (error) {
      Callback.snackBar(context);
    }
    setState(() => _loading = false);
  }

  _addFileToUpload(Future<String?> Function(String, String) filesUpload) {
    _filesUpload.add(filesUpload);
  }

  @override
  void initState() {
    super.initState();
    _filesSaved.addAll(widget.images);
  }

  @override
  Widget build(BuildContext context) {
    final traslation =
        Translations.of(context).translate('update_images_screen');
    _filesUpload.clear();

    return Scaffold(
      appBar: AppBar(
        title: Text(traslation["title"]),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.close),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          children: [
            FilesContainer(
              addFile: _addFile,
              addFileToUpload: _addFileToUpload,
              files: _files,
              filesSaved: _filesSaved,
              removeFiles: _removeFiles,
              removeFilesSaved: _removeFilesSaved,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                traslation["edit_info"],
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: ElevatedButton(
                onPressed: _loading && _filesSaved.isEmpty ? null : _submitForm,
                child: LoadingIndicator(
                  loading: _loading,
                  child: Text(
                    traslation["save"],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilesContainer extends StatefulWidget {
  const FilesContainer({
    super.key,
    required this.addFile,
    required this.addFileToUpload,
    required this.files,
    required this.filesSaved,
    required this.removeFiles,
    required this.removeFilesSaved,
  });

  final Function(File) addFile;
  final dynamic Function(Future<String?> Function(String, String))
      addFileToUpload;
  final List<File> files;
  final List<String> filesSaved;
  final Function(List<int>) removeFiles;
  final Function(List<int>) removeFilesSaved;

  @override
  State<FilesContainer> createState() => _FilesContainerState();
}

class _FilesContainerState extends State<FilesContainer> {
  final List<int> _filesSelected = [];

  final List<int> _filesSelectedSaved = [];

  _deleteFiles() async {
    widget.removeFiles(_filesSelected);
    widget.removeFilesSaved(_filesSelectedSaved);
    _filesSelected.clear();
    _filesSelectedSaved.clear();
  }

  Widget fileImage({
    File? file,
    required String path,
    required bool selected,
    required inSelection,
  }) {
    return SizedBox(
      height: 88.0,
      width: 88.0,
      child: FileViewUpload(
        file: file,
        addFileToUpload: widget.addFileToUpload,
        child: Stack(
          children: [
            AppImage(
              imageUrl: path,
              withHero: !inSelection,
            ),
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: selected
                  ? BoxDecoration(color: Colors.blue.withOpacity(.3))
                  : null,
            )
          ],
        ),
      ),
    );
  }

  List<Widget> filesRender(bool inSelection) {
    final List<Widget> files = [];
    for (int i = 0; i < widget.files.length; i++) {
      final file = widget.files[i];
      final path = file.path;
      final selected = _filesSelected.contains(i);

      toggleState() {
        setState(() {
          !selected
              ? _filesSelected.add(i)
              : _filesSelected.removeWhere((index) => index == i);
        });
      }

      files.add(InkWell(
        onLongPress: toggleState,
        onTap: inSelection ? toggleState : null,
        child: fileImage(
          file: file,
          path: path,
          selected: selected,
          inSelection: inSelection,
        ),
      ));
    }

    return files;
  }

  List<Widget> filesSavedRender(bool inSelection) {
    final List<Widget> files = [];
    for (int i = 0; i < widget.filesSaved.length; i++) {
      final file = widget.filesSaved[i];
      final path = file;
      final selected = _filesSelectedSaved.contains(i);

      toggleState() {
        setState(() {
          !selected
              ? _filesSelectedSaved.add(i)
              : _filesSelectedSaved.removeWhere((index) => index == i);
        });
      }

      files.add(InkWell(
        onLongPress: toggleState,
        onTap: inSelection ? toggleState : null,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          constraints: const BoxConstraints(maxWidth: 88.0, maxHeight: 88.0),
          child: fileImage(
            path: path,
            selected: selected,
            inSelection: inSelection,
          ),
        ),
      ));
    }

    return files;
  }

  @override
  Widget build(BuildContext context) {
    final inSelection =
        _filesSelectedSaved.isNotEmpty || _filesSelected.isNotEmpty;
    const maxImages = 10;
    final amountFiles = widget.files.length + widget.filesSaved.length;
    final traslation =
        Translations.of(context).translate('update_images_screen');
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                traslation["photos"].replaceAll(
                  "{amount}",
                  "$amountFiles/$maxImages",
                ),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            if (inSelection)
              IconButton(
                onPressed: _deleteFiles,
                icon: Icon(
                  Icons.delete_forever,
                  color: Theme.of(context).colorScheme.error,
                  size: 32,
                ),
              ),
          ],
        ),
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            ...filesSavedRender(inSelection),
            ...filesRender(inSelection),
            if (amountFiles < maxImages)
              FileViewUpload(
                addFileToUpload: widget.addFileToUpload,
                child: FileInput(widget.addFile),
              )
          ],
        ),
      ],
    );
  }
}

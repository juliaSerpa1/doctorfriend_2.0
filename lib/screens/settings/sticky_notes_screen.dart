import 'package:doctorfriend/components/callback.dart';
import 'package:doctorfriend/components/custom_input.dart';
import 'package:doctorfriend/components/loading_indicator.dart';
import 'package:doctorfriend/exeption/firestore_exception.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/models/sticky_note.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:doctorfriend/services/stickyNotes/sticky_notes_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:flutter/material.dart';

class StickyNotesScreen extends StatefulWidget {
  const StickyNotesScreen({super.key});

  @override
  State<StickyNotesScreen> createState() => _StickyNotesScreenState();
}

class _StickyNotesScreenState extends State<StickyNotesScreen> {
  final AppUser _user = AuthService().currentUser!;
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _isEdit = false;
  late Map<String, dynamic> _stickyNotes = {};

  void _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();
    _handleSave();
  }

  Future<void> _handleSave() async {
    setState(() => _loading = true);
    try {
      List<String> stickyNotes = [];
      _stickyNotes.forEach((key, value) {
        stickyNotes.add(value);
      });
      await StickyNotesService().addStickyNote(
        StickyNote(stickyNotes: stickyNotes, userId: _user.id),
      );
      _isEdit = false;
    } on FirestoreException catch (error) {
      Navigator.of(context).pop();
      Callback.snackBar(context, title: error.message);
    } catch (error) {
      Navigator.of(context).pop();
      Callback.snackBar(context);
    }

    setState(() => _loading = false);
  }

  _addFiel() {
    _stickyNotes.putIfAbsent(_stickyNotes.length.toString(), () => "");
    setState(() {});
  }

  _removeFiel(String objectKey) async {
    setState(() => _loading = true);

    final stickyNotes = {..._stickyNotes};
    stickyNotes.removeWhere((key, value) => objectKey == key);
    _stickyNotes.clear();
    List<String> stickyNotesList = [];
    stickyNotes.forEach((key, value) {
      stickyNotesList.add(value);
    });
    for (int i = 0; i < stickyNotesList.length; i++) {
      _stickyNotes.putIfAbsent(i.toString(), () => stickyNotesList[i]);
    }
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() => _loading = false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  _loadData() {
    _stickyNotes = {"0": ""};
    StickyNotesService().stickyNote(_user.id).listen((event) async {
      if (event != null) {
        if (event.stickyNotes.isNotEmpty) {
          _stickyNotes.clear();
          for (int i = 0; i < event.stickyNotes.length; i++) {
            _stickyNotes.putIfAbsent(i.toString(), () => event.stickyNotes[i]);
          }
          setState(() {
            _loading = true;
          });
          await Future.delayed(const Duration(milliseconds: 100));
          setState(() {
            _loading = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final traslation =
        Translations.of(context).translate('sticky_notes_screen');

    List<Widget> inputs() {
      final List<Widget> res = [];
      _stickyNotes.forEach(
        (key, value) {
          res.add(
            Stack(
              children: [
                if (!_loading)
                  CustomInput(
                    formData: _stickyNotes,
                    objectKey: key,
                    onChanged: (val) => _stickyNotes[key] = val,
                    label: traslation["sticky_note_number"].replaceAll(
                      "{amount}",
                      (int.parse(key) + 1).toString(),
                    ),
                    keyboardType: TextInputType.multiline,
                    requiredField: _isEdit,
                    readOnly: !_isEdit,
                  )
                else
                  const SizedBox(height: 150),
                if (_isEdit)
                  Positioned(
                    right: 0,
                    top: 10,
                    child: IconButton(
                      onPressed: () => _removeFiel(key),
                      icon: Icon(
                        Icons.remove_circle,
                        size: 25,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      );

      return res;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(traslation["title"]),
        actions: [
          IconButton(
            onPressed: () => setState(() {
              if (_isEdit) {
                _loadData();
              }
              _isEdit = !_isEdit;
            }),
            icon: Icon(_isEdit ? Icons.close_sharp : Icons.edit),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    traslation["help"],
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                ...inputs(),
                if (_isEdit)
                  IconButton(
                    onPressed: _addFiel,
                    icon: Icon(
                      Icons.add_box_rounded,
                      size: 33,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                if (_isEdit)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: ElevatedButton(
                      onPressed: _loading ? null : _submitForm,
                      child: LoadingIndicator(
                        loading: _loading,
                        child: Text(traslation["save"]),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

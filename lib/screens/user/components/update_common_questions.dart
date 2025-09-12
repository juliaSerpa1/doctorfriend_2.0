import 'package:doctorfriend/components/callback.dart';
import 'package:doctorfriend/components/custom_input.dart';
import 'package:doctorfriend/components/loading_indicator.dart';
import 'package:doctorfriend/exeption/firestore_exception.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/models/common_question.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/services/users/users_service.dart';
import 'package:flutter/material.dart';

class UpdateCommonQuestions extends StatefulWidget {
  final List<CommonQuestion> commonQuestions;
  const UpdateCommonQuestions({
    super.key,
    required this.commonQuestions,
  });

  @override
  State<UpdateCommonQuestions> createState() => _UpdateContactState();
}

class _UpdateContactState extends State<UpdateCommonQuestions> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  late Map<String, dynamic> _commonQuestions = {};

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
      List<CommonQuestion> commonQuestions = [];
      _commonQuestions.forEach((key, value) {
        commonQuestions.add(CommonQuestion(
          question: value["question"],
          response: value["response"],
        ));
      });
      final AppUser user = AuthService().currentUser!;
      await UsersService().updateUserCommonQuestion(
        userId: user.id,
        commonQuestions: commonQuestions,
      );
    } on FirestoreException catch (error) {
      Callback.snackBar(context, title: error.message);
    } catch (error) {
      Callback.snackBar(context);
    }
    Navigator.of(context).pop();
    setState(() => _loading = false);
  }

  _addFiel() {
    _commonQuestions.putIfAbsent(
      _commonQuestions.length.toString(),
      () => {
        "question": "",
        "response": "",
      },
    );
    setState(() {});
  }

  _removeFiel(String objectKey) async {
    setState(() => _loading = true);

    final services = {..._commonQuestions};
    services.removeWhere((key, value) => objectKey == key);
    _commonQuestions.clear();
    List<Map<String, dynamic>> commonQuestions = [];
    services.forEach((key, value) {
      commonQuestions.add(value);
    });
    for (int i = 0; i < commonQuestions.length; i++) {
      _commonQuestions.putIfAbsent(
        i.toString(),
        () => {
          "question": commonQuestions[i]["question"],
          "response": commonQuestions[i]["response"],
        },
      );
    }
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() => _loading = false);
  }

  @override
  void initState() {
    super.initState();
    final commonQuestions = widget.commonQuestions;
    if (commonQuestions.isNotEmpty) {
      for (int i = 0; i < commonQuestions.length; i++) {
        _commonQuestions.putIfAbsent(
          i.toString(),
          () => {
            "question": commonQuestions[i].question,
            "response": commonQuestions[i].response,
          },
        );
      }
    } else {
      _commonQuestions = {
        "0": {"question": "", "response": ""}
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final traslation =
        Translations.of(context).translate('update_common_questions');
    List<Widget> inputs() {
      final List<Widget> res = [];
      _commonQuestions.forEach((key, value) {
        res.add(Stack(
          children: [
            if (!_loading)
              Column(
                children: [
                  CustomInput(
                    formData: _commonQuestions[key],
                    objectKey: "question",
                    onChanged: (val) => _commonQuestions[key]["question"] = val,
                    label: traslation["question"]
                        .replaceAll("{amount}", "${int.parse(key) + 1}"),
                  ),
                  CustomInput(
                    formData: _commonQuestions[key],
                    objectKey: "response",
                    onChanged: (val) => _commonQuestions[key]["response"] = val,
                    label: traslation["response"]
                        .replaceAll("{amount}", "${int.parse(key) + 1}"),
                    keyboardType: TextInputType.multiline,
                  ),
                  const Divider(),
                ],
              )
            else
              const SizedBox(height: 170),
            Positioned(
              right: 5,
              top: 15,
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
        ));
      });

      return res;
    }

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Text(
                traslation["title"],
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ...inputs(),
            IconButton(
              onPressed: _addFiel,
              icon: Icon(
                Icons.add_box_rounded,
                size: 33,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
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
    );
  }
}

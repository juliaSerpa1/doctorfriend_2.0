import 'package:doctorfriend/components/callback.dart';
import 'package:doctorfriend/components/custom_input.dart';
import 'package:doctorfriend/components/loading_indicator.dart';
import 'package:doctorfriend/exeption/firestore_exception.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/services/users/users_service.dart';
import 'package:flutter/material.dart';

class UpdateAboutMe extends StatefulWidget {
  final String text;

  const UpdateAboutMe({
    super.key,
    required this.text,
  });

  @override
  State<UpdateAboutMe> createState() => _UpdateAboutMeState();
}

class _UpdateAboutMeState extends State<UpdateAboutMe> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  final TextEditingController _controllerText = TextEditingController();

  void _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();
    _handleSignup();
  }

  Future<void> _handleSignup() async {
    setState(() => _loading = true);
    try {
      final AppUser user = AuthService().currentUser!;
      await UsersService().updateUserAboutMe(
        userId: user.id,
        aboutMe: _controllerText.text,
      );
    } on FirestoreException catch (error) {
      Callback.snackBar(context, title: error.message);
    } catch (error) {
      Callback.snackBar(context);
    }
    Navigator.of(context).pop();
    setState(() => _loading = false);
  }

  @override
  void initState() {
    super.initState();
    _controllerText.text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    int limitText = 800;
    final traslation = Translations.of(context).translate('update_about_me');
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
            CustomInput(
              label: traslation["label"],
              controller: _controllerText,
              requiredField: true,
              keyboardType: TextInputType.multiline,
              lines: 13,
              onChanged: (text) {
                if (text.length > limitText) {
                  _controllerText.text = text.substring(0, limitText);
                }
                setState(() {});
              },
              helperText: "${_controllerText.text.length}/$limitText",
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

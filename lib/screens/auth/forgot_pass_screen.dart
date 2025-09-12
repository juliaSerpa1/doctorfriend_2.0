import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:flutter/material.dart';
import 'package:doctorfriend/components/callback.dart';
import 'package:doctorfriend/components/custom_input.dart';
import 'package:doctorfriend/components/loading_indicator.dart';
import 'package:doctorfriend/exeption/firebase_auth_handle_exception.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:doctorfriend/utils/validator_util.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({super.key});

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  final TextEditingController _controllerEmail = TextEditingController();
  late Map<String, dynamic> _traslation;

  _sucess() async {
    await Callback.confirm(
      context: context,
      content: "${_traslation["success"]} ${_controllerEmail.text}",
      cancelText: "",
      confirmText: _traslation["confirm_text"],
    );
    Navigator.of(context).pop();
  }

  Future<void> _handleSendEmail() async {
    setState(() => _loading = true);
    try {
      final authService = AuthService();
      await authService.sendEmailToResetPassword(_controllerEmail.text);
      _sucess();
    } on FirebaseAuthHandleException catch (error) {
      Callback.snackBar(context, title: error.message);
    } catch (error) {
      Callback.snackBar(context);
    }
    setState(() => _loading = false);
  }

  void _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();
    _handleSendEmail();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _traslation = Translations.of(context).translate('forgot_pass_screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(shape: const ContinuousRectangleBorder()),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Center(
                child: Text(
                  _traslation["title"],
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
            ),
            CustomInput(
              label: _traslation["email"],
              controller: _controllerEmail,
              validator: ValidatorUtil.validateEmail,
              requiredField: true,
              onFieldSubmitted: (_) => _submitForm(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 55.0),
              child: ElevatedButton(
                onPressed: _loading ? null : _submitForm,
                child: LoadingIndicator(
                  loading: _loading,
                  child: Text(
                    _traslation["btn"],
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

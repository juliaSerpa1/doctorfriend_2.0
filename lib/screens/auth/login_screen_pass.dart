import 'dart:async';

import 'package:doctorfriend/components/custom_input.dart';
import 'package:doctorfriend/components/loading_indicator.dart';
import 'package:doctorfriend/exeption/handle_exception.dart';
import 'package:doctorfriend/screens/auth/components/logo.dart';
import 'package:doctorfriend/screens/auth/components/view_pass_icon.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/utils/app_routes_util.dart';
import 'package:doctorfriend/utils/validator_util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:doctorfriend/components/callback.dart';
import 'package:doctorfriend/exeption/firebase_auth_handle_exception.dart';
import 'package:doctorfriend/screens/auth/forgot_pass_screen.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:go_router/go_router.dart';

class LoginScreenPass extends StatefulWidget {
  const LoginScreenPass({super.key});

  @override
  State<LoginScreenPass> createState() => _LoginScreenPassState();
}

class _LoginScreenPassState extends State<LoginScreenPass> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _isComplete = false;
  bool _obscureText = true;
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  late Map<String, dynamic> _traslation;

  Future<void> _updateAccount() async {
    final res = await Callback.confirm(
      context: context,
      title: _traslation["update_account_title"],
      content: _traslation["update_account_content"],
    );
    if (res) {
      final bool? updated =
          await context.push(AppRoutesUtil.signup, extra: {'updateUser': true});
      if (updated != null) {
        await _handleLogin();
      }
    }
  }

  Future<void> _handleLogin() async {
    try {
      setState(() => _loading = true);
      // await AuthService().login(
      //   _controllerEmail.text,
      //   _controllerPassword.text,
      // );
      await AuthService().signInWithGoogle();
    } on FirebaseAuthHandleException catch (error) {
      Callback.snackBar(context, title: error.message);
    } on HandleException catch (error) {
      if (error.message.toLowerCase() != "erro: userweb") {
        Callback.snackBar(context, title: error.message);
      } else {
        _updateAccount();
      }
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

    _handleLogin();
  }

  void _foggotPass() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const ForgotPassScreen();
        },
      ),
    );
  }

  void isComplete(String _) {
    bool res = false;
    if (_controllerEmail.text.trim() != "" &&
        _controllerPassword.text.trim() != "") {
      res = true;
    }
    if (res != _isComplete) {
      setState(() {
        _isComplete = res;
      });
    }
  }

  Future<bool> _isAuthorized() async {
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  @override
  void initState() {
    super.initState();
    _isAuthorized();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _traslation = Translations.of(context).translate('login_screen');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            const Logo(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0, bottom: 30.0),
                    child: Center(
                      child: Text(
                        _traslation["title"],
                        style: theme.textTheme.displayLarge,
                      ),
                    ),
                  ),
                  // if (GoogleSignIn.instance.supportsAuthenticate())
                  CustomInput(
                    label: _traslation["email"],
                    controller: _controllerEmail,
                    validator: ValidatorUtil.validateEmail,
                    requiredField: true,
                    onChanged: isComplete,
                    textCapitalization: TextCapitalization.none,
                  ),
                  CustomInput(
                    label: _traslation["pass"],
                    obscureText: _obscureText,
                    controller: _controllerPassword,
                    validator: ValidatorUtil.validatePassoword,
                    requiredField: true,
                    onFieldSubmitted: (_) => _submitForm(),
                    textCapitalization: TextCapitalization.none,
                    onChanged: isComplete,
                    suffixIcon: ViewPassIcon(
                      obscureText: _obscureText,
                      onPressed: () =>
                          setState(() => _obscureText = !_obscureText),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 55),
                      child: ElevatedButton(
                        onPressed:
                            _loading || !_isComplete ? null : _submitForm,
                        child: LoadingIndicator(
                          loading: _loading,
                          child: Text(_traslation["enter"]),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: _foggotPass,
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        child: Text(_traslation["forgot_pass"]),
                      ),
                      TextButton(
                        onPressed: () => context.push(AppRoutesUtil.signup),
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        child: Text(_traslation["register"]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

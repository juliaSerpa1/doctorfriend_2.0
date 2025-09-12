import 'dart:async';

import 'package:doctorfriend/exeption/handle_exception.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:flutter/material.dart';
import 'package:doctorfriend/components/callback.dart';
import 'package:doctorfriend/exeption/firebase_auth_handle_exception.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class WithApple extends StatelessWidget {
  final Function(bool) setLoading;
  const WithApple({
    super.key,
    required this.setLoading,
  });

  @override
  Widget build(BuildContext context) {
    Future<void> handleLogin() async {
      try {
        setLoading(true);
        await AuthService().signInWithApple();
      } on FirebaseAuthHandleException catch (error) {
        Callback.snackBar(context, title: error.message);
      } on HandleException catch (error) {
        Callback.snackBar(context, title: error.message);
      } catch (error) {
        Callback.snackBar(context);
      }
      setLoading(false);
    }

    final traslation = Translations.of(context).translate('login_screen');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 60.0),
      constraints: BoxConstraints(
        maxWidth: 380.0,
      ),
      child: Transform.scale(
        scale: 1.3, // aumenta o tamanho geral
        child: SignInButton(
          Buttons.Apple,
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 12.0,
          ),
          elevation: 5,
          width: double.infinity,
          onPressed: handleLogin,
          text: traslation["apple"],
        ),
      ),
    );
  }
}

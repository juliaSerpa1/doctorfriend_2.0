import 'dart:async';

import 'package:doctorfriend/components/loading_indicator.dart';
import 'package:doctorfriend/screens/auth/components/logo.dart';
import 'package:doctorfriend/screens/auth/components/with_apple.dart';
import 'package:doctorfriend/screens/auth/components/with_google.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/services/users/users_service.dart';
import 'package:doctorfriend/utils/app_routes_util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:doctorfriend/components/callback.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  late Map<String, dynamic> _traslation;

  Future<void> _updateAccount([bool updateUser = false]) async {
    if (!mounted) return;
    bool res = true;
    if (updateUser) {
      res = await Callback.confirm(
        context: context,
        title: _traslation["update_account_title"],
        content: _traslation["update_account_content"],
      );
    }
    if (res) {
      // final bool? updated =
      if (mounted) {
        await context
            .push(AppRoutesUtil.signup, extra: {'updateUser': updateUser});
      }
      // if (updated != null) {
      //   await _handleLogin();
      // }
    } else {
      await AuthService().logout();
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

  void _authUserChanges() {
    AuthService().userChanges.listen((data) async {
      final authUser = AuthService().authUser;
      if (!AuthService().toSignup || authUser == null) return;

      final use = await UsersService().getUser(authUser.uid);
      if (use == null || use.specialty.isEmpty) {
        final userWeb = await UsersService().getUserCustomer(authUser.uid);
        if (userWeb == null) {
          _updateAccount();
        } else {
          _updateAccount(true);
        }
      }
    }).onError((error) {
      Callback.snackBar(context);
    });
  }

  @override
  void initState() {
    super.initState();
    _isAuthorized();
    _authUserChanges();
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
                      child: LoadingIndicator(
                        loading: _loading,
                        child: Text(
                          _traslation["title"],
                          style: theme.textTheme.displayLarge,
                        ),
                      ),
                    ),
                  ),
                  // if (GoogleSignIn.instance.supportsAuthenticate())
                  WithGoogle(
                    setLoading: (loading) => setState(() => _loading = loading),
                  ),
                  const SizedBox(height: 40.0),
                  WithApple(
                    setLoading: (loading) => setState(() => _loading = loading),
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

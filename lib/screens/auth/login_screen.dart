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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:doctorfriend/exeption/firebase_auth_handle_exception.dart';
import 'package:doctorfriend/exeption/firestore_exception.dart';
import 'package:doctorfriend/exeption/handle_exception.dart';
import 'package:doctorfriend/screens/auth/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  late Map<String, dynamic> _traslation;

  // Controladores para os campos de email e senha
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  bool _obscureText = true;

Future<void> _handleEmailLogin() async {
  try {
    setState(() => _loading = true);

    try {
      // Tentando fazer login com email e senha
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _controllerEmail.text.trim(),
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        // Se o usuário não for encontrado, redireciona para a tela de cadastro
        await context.push(AppRoutesUtil.signup, extra: {
          'email': _controllerEmail.text.trim(),
        });
      } else {
        // Se for outro erro, exibe o erro para o usuário
        Callback.snackBar(context, title: error.message);
        return;
      }
    }

    // Se tudo ocorrer bem, redireciona para a página inicial
    context.push(AppRoutesUtil.home);
  } catch (error) {
    // Se ocorrer erro inesperado
    Callback.snackBar(context);
  } finally {
    setState(() => _loading = false);
  }
}


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
  _traslation = Translations.of(context).translate('login_screen') ?? {};
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
                    // **Campos de Email e Senha**
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      controller: _controllerEmail,
                      decoration: InputDecoration(
                        labelText: _traslation["email"] ?? "Email",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return _traslation["email_required"] ?? "Email is required";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      controller: _controllerPassword,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelText: _traslation["password"] ?? "Password", // Fallback
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return _traslation["password_required"] ?? "Password is required";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // **Botão de Login com E-mail e Senha**
                  ElevatedButton(
                    onPressed: _loading
                        ? null
                        : () {
                            if (_formKey.currentState?.validate() ?? false) {
                              _handleEmailLogin();
                            }
                          },
                    child: LoadingIndicator(
                      loading: _loading,
                    child: Text(_traslation["login_with_email"] ?? "Login with Email"), // Fallback
                    ),
                  ),
                  const SizedBox(height: 40.0),
              
                  // **Botões de login com Google e Apple**
                  // if (GoogleSignIn.instance.supportsAuthenticate())
                  WithGoogle(
                    setLoading: (loading) => setState(() => _loading = loading),
                  ),
                  const SizedBox(height: 40.0),
                  WithApple(
                    setLoading: (loading) => setState(() => _loading = loading),
                  ),

                  // Adicionando o botão de cadastro
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: TextButton(
                      onPressed: () {
                        // Redireciona para a tela de cadastro com o email do usuário (se existir)
                        context.push(
                          AppRoutesUtil.signup,
                          extra: {'email': _controllerEmail.text.trim()},  // Passando o e-mail
                        );
                      },
                      child: Text(_traslation["signup"] ?? "Cadastre-se", style: TextStyle(fontSize: 16.0)),  // Texto para o botão
                    ),
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

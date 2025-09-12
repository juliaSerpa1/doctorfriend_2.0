import 'package:doctorfriend/exeption/firebase_auth_handle_exception.dart';
import 'package:doctorfriend/exeption/firestore_exception.dart';
import 'package:doctorfriend/exeption/handle_exception.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:flutter/material.dart';
import 'package:doctorfriend/components/callback.dart';
import 'package:doctorfriend/components/loading_indicator.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:go_router/go_router.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  // bool _obscureText = true;
  // AppUser? _user;
  late Map<String, dynamic> _traslation;

  Future<void> _sucess() async {
    if (mounted) {
      Callback.snackBar(context, error: false);
      context.replace("/");
    }
  }

  void _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();
    _handleDeleteAccount();
  }

  Future<void> _handleDeleteAccount() async {
    try {
      final bool res = await Callback.confirm(
        title: _traslation["confirm_title"],
        context: context,
        content: _traslation["confirm_content"],
      );
      if (!res) {
        return;
      }
      setState(() => _loading = true);

      final authService = AuthService();
      await authService.deleteAccount();
      _sucess();
    } on FirebaseAuthHandleException catch (error) {
      Callback.snackBar(context, title: error.message);
    } on FirestoreException catch (error) {
      Callback.snackBar(context, title: error.message);
    } on HandleException catch (error) {
      Callback.snackBar(context, title: error.message);
    } catch (error) {
      Callback.snackBar(context);
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _traslation = Translations.of(context).translate('delete_account_screen');
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
            // CustomInput(
            //   label: _traslation["pass"],
            //   obscureText: _obscureText,
            //   controller: _controllerPassword,
            //   validator: ValidatorUtil.validatePassoword,
            //   requiredField: true,
            //   onFieldSubmitted: (_) => _submitForm(),
            //   suffixIcon: ViewPassIcon(
            //     obscureText: _obscureText,
            //     onPressed: () => setState(() => _obscureText = !_obscureText),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 55.0),
              child: ElevatedButton(
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onBackground,
                ),
                onPressed: _loading ? null : _submitForm,
                child: LoadingIndicator(
                  loading: _loading,
                  child: Text(_traslation["delete"]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

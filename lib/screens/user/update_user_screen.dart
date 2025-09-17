import 'dart:io';

import 'package:doctorfriend/components/custom_input_sugest.dart';
import 'package:doctorfriend/components/file_input.dart';
import 'package:doctorfriend/exeption/firestore_exception.dart';
import 'package:doctorfriend/exeption/handle_exception.dart';
import 'package:doctorfriend/models/fields_of_practice.dart';
import 'package:doctorfriend/models/profession.dart';
import 'package:doctorfriend/services/appData/suggestions_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/utils/app_routes_util.dart';
import 'package:flutter/material.dart';
import 'package:doctorfriend/components/callback.dart';
import 'package:doctorfriend/components/custom_input.dart';
import 'package:doctorfriend/components/loading_indicator.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:go_router/go_router.dart';

class UpdateUserScreen extends StatefulWidget {
  const UpdateUserScreen({super.key});

  @override
  State<UpdateUserScreen> createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  late AuthService _authService;
  AppUser? _user;
  bool _loadSpecialties = false;

  Profession? _profisionSelected;

  final List<Specialties> _specialties = [];

  File? _selectedImage;
  final List<Profession> _suggestionsprofessions = [];
  late Map<String, dynamic> _traslation;

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerprofession = TextEditingController();
  final TextEditingController _controllerspecialty = TextEditingController();

  Future<void> _handleSave() async {
    setState(() => _loading = true);
    try {
      final String lang = Translations.currentLocale.languageCode;
      Profession? profession;
      try {
        profession = _suggestionsprofessions.firstWhere((val) =>
            val.name.toLowerCase() ==
            _controllerprofession.text.toLowerCase().trimRight());
      } catch (_) {}
      Specialties? specialty;
      try {
        specialty = _specialties.firstWhere((val) =>
            val.name.toLowerCase() ==
            _controllerspecialty.text.toLowerCase().trimRight());
      } catch (_) {}

      if (profession == null) {
        throw HandleException("select_profession", lang);
      }
      if (specialty == null) {
        throw HandleException("select_specialty", lang);
      }
      await _authService.editProfile(
        name: _controllerName.text,
        profession: profession.id,
        specialty: specialty.id,
        registerClassOrder: _profisionSelected?.classOrder,
        image: _selectedImage,
      );
      Callback.snackBar(context, error: false);
      Navigator.of(context).pop();
    } on FirestoreException catch (error) {
      Callback.snackBar(context, title: error.message);
    } on HandleException catch (error) {
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
    _handleSave();
  }

  void _handleDeleteAccount() {
    context.push(AppRoutesUtil.deleteAccount);
  }

  Future<void> _loadSuggestions() async {
    _suggestionsprofessions.clear();
    final suggestions = await AppDataService().getProfessions();
    _suggestionsprofessions.addAll([...suggestions]);
    setState(() {});
    _onProfissionChange("");
  }

  void _onSelectImage(File file) {
    setState(() {
      _selectedImage = file;
    });
  }

  // _sucess() async {
  //   await Callback.confirm(
  //     context: context,
  //     content: _traslation["email_sended"].replaceAll(
  //       "{email}",
  //       _controllerEmail.text,
  //     ),
  //     cancelText: "",
  //     confirmText: _traslation["email_sended_confirm"],
  //   );
  // }

  // Future<void> _handleSendEmail() async {
  //   try {
  //     final bool res = await Callback.confirm(
  //         context: context, content: _traslation["request_reset_pass_title"]);
  //     if (!res) {
  //       return;
  //     }
  //     setState(() => _loading = true);

  //     final authService = AuthService();
  //     await authService.sendEmailToResetPassword(_controllerEmail.text);
  //     _sucess();
  //   } on FirestoreException catch (error) {
  //     Callback.snackBar(context, title: error.message);
  //   } catch (error) {
  //     Callback.snackBar(context);
  //   }
  //   setState(() => _loading = false);
  // }

  Future<void> _onProfissionChange(String _) async {
    for (final profision in _suggestionsprofessions) {
      if (profision.name.toLowerCase() ==
          _controllerprofession.text.toLowerCase()) {
        _profisionSelected = profision;
      }
    }
    _loadSpecialties = true;
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 200));
    _specialties.clear();
    _specialties.addAll([..._profisionSelected?.specialties ?? []]);
    _loadSpecialties = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _user = _authService.currentUser;
    if (_user != null) {
      _controllerName.text = _user!.name;
      final profession = _user!.getProfession?.name ?? "";
      final specialty = _user!.getProfession != null &&
              _user!.getProfession!.specialties.isNotEmpty
          ? _user!.getProfession!.specialties.first.name
          : "";
      _controllerprofession.text = profession;
      _controllerspecialty.text = specialty;
    }
    _loadSuggestions();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _traslation = Translations.of(context).translate('update_user_screen');
  }

  @override
  Widget build(BuildContext context) {
    final profession = _suggestionsprofessions.map((val) => val.name).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(_traslation["title"]),
      ),
      body: Builder(builder: (context) {
        return Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: SizedBox(
                    width: 120,
                    height: 120,
                    child: FileInput(
                      _onSelectImage,
                      selectedImage: _user?.imageUrl,
                      isCircular: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomInput(
                label: _traslation["name"],
                controller: _controllerName,
                requiredField: true,
              ),
              CustomInputSugest(
                label: _traslation["profession"],
                controller: _controllerprofession,
                suggestions: profession,
                requiredField: true,
                onChanged: _onProfissionChange,
              ),
              if (!_loadSpecialties)
                CustomInputSugest(
                  label: _traslation["specialty"],
                  controller: _controllerspecialty,
                  suggestions: _specialties.map((el) => el.name).toList(),
                  requiredField: true,
                  done: true,
                ),
              // CustomInput(
              //   label: _traslation["pass"],
              //   obscureText: true,
              //   controller: _controllerPassword,
              //   validator: ValidatorUtil.validatePassoword,
              //   requiredField: true,
              //   onFieldSubmitted: (_) => _submitForm(),
              //   textCapitalization: TextCapitalization.none,
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 25.0),
                child: ElevatedButton(
                  onPressed: _loading ? null : _submitForm,
                  child: LoadingIndicator(
                    loading: _loading,
                    child: Text(_traslation["save"]),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // TextButton(
                  //   style: TextButton.styleFrom(
                  //     textStyle: const TextStyle(
                  //       decoration: TextDecoration.underline,
                  //     ),
                  //   ),
                  //   onPressed: _handleSendEmail,
                  //   child: LoadingIndicator(
                  //     loading: _loading,
                  //     child: Text(_traslation["update_pass"]),
                  //   ),
                  // ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                      textStyle: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    onPressed: _handleDeleteAccount,
                    child: Text(_traslation["delete_account"]),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}

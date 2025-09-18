import 'package:doctorfriend/components/custom_checkbox.dart';
import 'package:doctorfriend/components/custom_input_sugest.dart';
import 'package:doctorfriend/components/input_location_sugest.dart';
import 'package:doctorfriend/exeption/firestore_exception.dart';
import 'package:doctorfriend/exeption/handle_exception.dart';
import 'package:doctorfriend/models/app_data.dart';
import 'package:doctorfriend/models/fields_of_practice.dart';
import 'package:doctorfriend/models/profession.dart';
import 'package:doctorfriend/services/appData/suggestions_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/services/users/users_service.dart';
import 'package:doctorfriend/utils/app_routes_util.dart';
import 'package:doctorfriend/utils/tools_util.dart';
import 'package:flutter/material.dart';
import 'package:doctorfriend/components/callback.dart';
import 'package:doctorfriend/components/custom_input.dart';
import 'package:doctorfriend/components/loading_indicator.dart';
import 'package:doctorfriend/exeption/firebase_auth_handle_exception.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/gestures.dart';

class SignupScreen extends StatefulWidget {
  final bool updateUser;
  const SignupScreen({
    super.key,
    this.updateUser = false,
  });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  bool _loading = false;
  bool _agreeTerms = false;
  bool _agreeContact = false;
  bool _isComplete = false;
  bool _updateUser = false;
  bool _loadSpecialties = false;
  double? _lat;
  double? _lng;
  String? _local;

  Profession? _profisionSelected;

  final List<Specialties> _specialties = [];

  final List<Profession> _suggestionsprofessions = [];

  final TextEditingController _controllerPhone =
      TextEditingController(text: "+55 ");
  final TextEditingController _controllerLocation = TextEditingController();

  final TextEditingController _controllerprofession = TextEditingController();
  final TextEditingController _controllerspecialty = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  // final TextEditingController _controllerEmail = TextEditingController();
  // final TextEditingController _controllerPassword = TextEditingController();
  // final TextEditingController _controllerConfirmPassword =
  //     TextEditingController();
  final TextEditingController _controllerRegisterNumber =
      TextEditingController();

  late Map<String, dynamic> _traslation;
  AppData? _appData;
  bool _isFromApple = false;
  Future<void> _loadData() async {
    setState(() => _loading = true);
    _appData = await AppDataService().getAppData();
    setState(() => _loading = false);
  }

  Future<void> _handleSignup() async {
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
      await _authService.signup(
        name: _isFromApple ? null : _controllerName.text,
        phone: _controllerPhone.text,
        local: _controllerLocation.text,
        latitude: _lat!,
        longitude: _lng!,
        profession: profession.id,
        specialty: specialty.id,
        registerClassOrder: _profisionSelected?.classOrder,
        registerNumber: _controllerRegisterNumber.text,
        terms: _agreeTerms,
        norms: _agreeContact,
        isHealthInsurance: false,
      );
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

  void _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }
    if (_lat == null || _lng == null || _local == null) {
      //garate que tem uma localização
      return Callback.snackBar(context, title: _traslation["no_lat_lng"]);
    }
    _formKey.currentState?.save();
    _handleSignup();
  }

  void isComplete(String _) {
    bool res = false;
    if (_controllerPhone.text.trim() != "" &&
        _controllerLocation.text.trim() != "" &&
        _controllerprofession.text.trim() != "" &&
        _agreeTerms &&
        _agreeContact) {
      res = true;
    }

    if (res != _isComplete) {
      setState(() {
        _isComplete = res;
      });
    }
  }

  Future<void> _loadSuggestions() async {
    _suggestionsprofessions.clear();
    final suggestions = await AppDataService().getProfessions();
    _suggestionsprofessions.addAll([...suggestions]);
    try {
      _controllerprofession.text =
          _suggestionsprofessions.firstWhere((val) => val.id == "medico").name;
      _onProfissionChange(_controllerprofession.text);
    } catch (_) {}
    setState(() {});
  }

  void _setLatLng(String lat, String lng) {
    //garate que tem uma localização
    try {
      _lat = double.parse(lat);
      _lng = double.parse(lng);
      _local = _controllerLocation.text;
      setState(() {});
    } catch (e) {
      //
    }
  }

  Future<void> _onProfissionChange(String text) async {
    isComplete(text);

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

  Future<void> logout() async {
    await AuthService().logout();
    if (mounted) context.push(AppRoutesUtil.login);
  }

  @override
  void initState() {
    super.initState();
    _loadSuggestions();
    _loadData();
    final authUser = AuthService().authUser;
    if (authUser == null) return;
    _updateUser = widget.updateUser;
    if (authUser.providerData.isNotEmpty) {
      if (authUser.providerData[0].providerId == "apple.com") {
        _isFromApple = true;
      }
    }
    _controllerName.text = authUser.displayName ?? "";
    _controllerPhone.text = authUser.phoneNumber ?? _controllerPhone.text;
    if (_updateUser) {
      getCutomerData();
    }
  }

  Future<void> getCutomerData() async {
    final authUser = AuthService().authUser;
    if (authUser == null) {
      return logout();
    }
    final userWeb = await UsersService().getUserCustomer(authUser.uid);
    _controllerName.text = userWeb?.name ?? "";
    _controllerPhone.text = userWeb?.phone ?? _controllerPhone.text;
    _controllerLocation.text = userWeb?.local ?? "";
    if (_controllerLocation.text.trim() != "") {
      _lat = userWeb?.coordinates.lat;
      _lng = userWeb?.coordinates.lng;
      _local = userWeb?.local;
    }
    _agreeTerms = userWeb?.terms != null ? true : false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _traslation = Translations.of(context).translate('signup_screen');
  }

  @override
  Widget build(BuildContext context) {
    final profession = _suggestionsprofessions.map((val) => val.name).toList();

    // final specialty = ["Sirurgiao", "Implantes"];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: logout,
          icon: Icon(Icons.close),
        ),
        title: Text(_traslation["title"]),
        shape: const ContinuousRectangleBorder(),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
          children: [
            InputLocationSugest(
              controller: _controllerLocation,
              label: _traslation["city"],
              requiredField: true,
              setLatLng: _setLatLng,
            ),
            CustomInputSugest(
              label: _traslation["profession"],
              controller: _controllerprofession,
              suggestions: profession,
              requiredField: true,
              onChanged: _onProfissionChange,
              done: true,
            ),
            if (!_loadSpecialties)
              CustomInputSugest(
                label: _traslation["specialty"],
                controller: _controllerspecialty,
                suggestions: _specialties.map((el) => el.name).toList(),
                requiredField: true,
                done: true,
              ),
            if (_profisionSelected != null)
              CustomInput(
                label: _profisionSelected?.classOrder ?? "",
                controller: _controllerRegisterNumber,
                requiredField: true,
                keyboardType: TextInputType.number,
                onChanged: isComplete,
              ),
            if (!_isFromApple)
              CustomInput(
                label: _traslation["name"],
                controller: _controllerName,
                requiredField: true,
                onChanged: isComplete,
              ),
            // CustomInput(
            //   label: _traslation["email"],
            //   controller: _controllerEmail,
            //   validator: ValidatorUtil.validateEmail,
            //   requiredField: true,
            //   onChanged: isComplete,
            //   textCapitalization: TextCapitalization.none,
            // ),
            CustomInput(
              label: _traslation["phone"],
              controller: _controllerPhone,
              requiredField: true,
              keyboardType: TextInputType.phone,
              onChanged: isComplete,
            ),

            // Row(
            //   children: [
            //     Expanded(
            //       flex: 2,
            //       child: Padding(
            //         padding: const EdgeInsets.only(right: 5),
            //         child: CustomInputSugest(
            //           label: _traslation["city"],
            //           controller: _controllerLocation,
            //           suggestions: _cities,
            //           requiredField: true,
            //           onChanged: isComplete,
            //         ),
            //       ),
            //     ),
            //     Expanded(
            //       child: CustomInputSugest(
            //         label: _traslation["state"],
            //         controller: _controllerState,
            //         suggestions:
            //             _states.map((e) => e['sigla'].toString()).toList(),
            //         requiredField: true,
            //         onChanged: isComplete,
            //         textCapitalization: TextCapitalization.characters,
            //       ),
            //     ),
            //   ],
            // ),
            // if (!_updateUser)
            //   CustomInput(
            //     label: _traslation["pass"],
            //     obscureText: _obscureText,
            //     controller: _controllerPassword,
            //     validator: ValidatorUtil.validatePassoword,
            //     requiredField: true,
            //     onFieldSubmitted: (_) => _submitForm(),
            //     textCapitalization: TextCapitalization.none,
            //     onChanged: isComplete,
            //     suffixIcon: ViewPassIcon(
            //       obscureText: _obscureText,
            //       onPressed: () => setState(() => _obscureText = !_obscureText),
            //     ),
            //   ),

            // if (!_updateUser)
            //   CustomInput(
            //     label: _traslation["pass_repeat"],
            //     obscureText: _obscureText,
            //     controller: _controllerConfirmPassword,
            //     validator: (value) => ValidatorUtil.validateConfirmPassword(
            //         _controllerPassword.text, value),
            //     requiredField: true,
            //     onFieldSubmitted: (_) => _submitForm(),
            //     textCapitalization: TextCapitalization.none,
            //     onChanged: isComplete,
            //     suffixIcon: ViewPassIcon(
            //       obscureText: _obscureText,
            //       onPressed: () => setState(() => _obscureText = !_obscureText),
            //     ),
            //   ),
            CustomCheckbox(
              label: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: _traslation["privacy_policy_text"],
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    TextSpan(
                      text: _traslation["privacy_policy_text_link"],
                      style: const TextStyle(
                        color: Colors.blue,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          ToolsUtil.launchURL(context,
                              urlString: _appData?.privacyPolicyURL ?? "");
                        },
                    ),
                  ],
                ),
              ),
              onChanged: (boo) {
                setState(() => _agreeTerms = boo ?? false);
                isComplete("_");
              },
              value: _agreeTerms,
            ),
            CustomCheckbox(
              label: Text(
                _traslation["contact_text_agree"],
                style: Theme.of(context).textTheme.bodySmall,
              ),
              onChanged: (boo) {
                setState(() => _agreeContact = boo ?? false);
                isComplete("_");
              },
              value: _agreeContact,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: ElevatedButton(
                onPressed: _loading || !_isComplete ? null : _submitForm,
                child: LoadingIndicator(
                  loading: _loading,
                  child: Text(_traslation["enter"]),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: logout,
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  child: Text(_traslation["login"]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

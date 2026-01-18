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
import 'package:doctorfriend/services/crm/crm_service.dart';
import 'package:doctorfriend/components/gradient_app_bar.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:doctorfriend/utils/validator_util.dart';
import 'package:doctorfriend/screens/auth/components/view_pass_icon.dart';
import 'package:doctorfriend/data/cities.dart';  // Aponte para o local correto onde o arquivo cities.dart está localizado
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatefulWidget {
  final bool updateUser;
  const SignupScreen({
    super.key,
    this.updateUser = false,
  });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class CityStateData {
  List<Map<String, dynamic>> states = [];

  // Função para carregar os estados e cidades do cities.dart
  void loadStatesAndCities() {
    states = List<Map<String, dynamic>>.from(citiesData['estados']);
  }
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

  bool _isFromApple = false;
  bool _isFromGoogle = false;

  // Nova variável para simplificar
  bool get _isSocialLogin => _isFromApple || _isFromGoogle;


  Profession? _profisionSelected;

  final List<Specialties> _specialties = [];

  final List<Profession> _suggestionsprofessions = [];

  final TextEditingController _controllerPhone =
      TextEditingController(text: "+55 ");
  final TextEditingController _controllerLocation = TextEditingController();

  final TextEditingController _controllerprofession = TextEditingController();
  final TextEditingController _controllerspecialty = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword =
      TextEditingController();
  final TextEditingController _controllerRegisterNumber =
      TextEditingController();

  late Map<String, dynamic> _traslation;
  AppData? _appData;


  late List<Map<String, dynamic>> _states;
  late List<String> _cities;
  final CityStateData _cityStateData = CityStateData();

  final TextEditingController _controllerState = TextEditingController();
  bool _obscureText = true;

  Future<void> _loadData() async {
    setState(() => _loading = true);
    _appData = await AppDataService().getAppData();
    setState(() => _loading = false);
  }

  Future<void> _loadStatesAndCities() async {
    _cityStateData.loadStatesAndCities();
    setState(() {
      _states = _cityStateData.states;
      _cities = _states.isNotEmpty ? List<String>.from(_states[0]['cidades']) : [];
    });
  }
 Future<void> _loadPreRegisterByCrm(String crm) async {
  try {
    final doc = await FirebaseFirestore.instance
        .collection("pre_registered_doctors")
        .doc(crm)
        .get();

    if (!doc.exists) return;

    final data = doc.data()!;

    // 🔒 impede reutilização do CRM
    if (data["linkedUid"] != null) {
      Callback.snackBar(
        context,
        title: "Este CRM já está vinculado a outra conta",
      );
      return;
    }

    // Nome
    if (data["name"] != null) {
      _controllerName.text = data["name"];
    }

    // CRM
    _controllerRegisterNumber.text = data["crm"] ?? crm;

    // Telefone
    if (data["phone"] != null && data["phone"].toString().isNotEmpty) {
      _controllerPhone.text = data["phone"];
    }

    // 🔒 cidade SEMPRE vazia
   // 📍 mantém localização se já estiver definida
if (_lat == null || _lng == null) {
  _controllerLocation.clear();
  _local = null;
}

    // Especialidade
    if (data["specialty"] != null) {
      _controllerspecialty.text = data["specialty"];
    }

    // Profissão fixa: médico
    try {
      _controllerprofession.text = _suggestionsprofessions
          .firstWhere((p) => p.id == "medico")
          .name;
      await _onProfissionChange(_controllerprofession.text);
    } catch (_) {}

    // Atualiza botão
    isComplete("_");

    setState(() {});
  } catch (e) {
    Callback.snackBar(
      context,
      title: "Erro ao buscar pré-cadastro do médico",
    );
  }
}

  Future<void> _handleSignup() async {
  setState(() => _loading = true);
  try {


    final String lang = Translations.currentLocale.languageCode;

     // 🔒 garante localização
    if (_lat == null || _lng == null) {
      throw HandleException("no_lat_lng", lang);
    }

    final crmService = CrmService();

    final crmResult = await crmService.isCrmAtivoBrasil(
      _controllerRegisterNumber.text.trim(),
    );

    if (!crmResult.isValido) {
      Callback.snackBar(
        context,
        title: crmResult.mensagem,
      );
      setState(() => _loading = false);
      return;
    }

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

   if (_isSocialLogin) {
  final authUser = AuthService().authUser;
  if (authUser == null) {
    throw HandleException("unexpected_error", lang);
  }
  await _authService.signup(
    name: authUser.displayName ?? _controllerName.text,
    phone: _controllerPhone.text,
    local: _controllerLocation.text,
    longitude: _lng!,
    latitude: _lat!,
    profession: profession.id,
    specialty: specialty.id,
    registerNumber: _controllerRegisterNumber.text,
    registerClassOrder: _profisionSelected?.classOrder,
    isHealthInsurance: false,
    terms: _agreeTerms,
    norms: _agreeContact,
  );

  await FirebaseFirestore.instance
    .collection("pre_registered_doctors")
    .doc(_controllerRegisterNumber.text.trim())
    .update({
  "linkedUid": authUser.uid,
  "status": "linked",
  "linkedAt": FieldValue.serverTimestamp(),
  });

  Callback.snackBar(context, error: false);
  context.go(AppRoutesUtil.home);
  return;
}

    // Aqui você utiliza o método de signup com e-mail e senha
    await _authService.signupWithEmailAndPassword(
      email: _isSocialLogin ? _controllerEmail.text.trim() : _controllerEmail.text.trim(),
      password: _isSocialLogin ? "" : _controllerPassword.text,
      name: _controllerName.text,
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
    final authUser = AuthService().authUser;
if (authUser == null) {
  throw HandleException("unexpected_error", lang);
}


    await FirebaseFirestore.instance
      .collection("pre_registered_doctors")
      .doc(_controllerRegisterNumber.text.trim())
      .update({
    "linkedUid": authUser.uid,
    "status": "linked",
    "linkedAt": FieldValue.serverTimestamp(),
    });

  } on FirebaseAuthHandleException catch (error) {
    Callback.snackBar(context, title: error.message);
  } on FirestoreException catch (error) {
    Callback.snackBar(context, title: error.message);
  } on HandleException catch (error) {
    Callback.snackBar(context, title: error.message);
 } catch (error, stack) {
  debugPrint("Signup error: $error");
  debugPrintStack(stackTrace: stack);
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
    _loadStatesAndCities();

    final authUser = AuthService().authUser;
    if (authUser != null && authUser.providerData.isNotEmpty) {
      final providerId = authUser.providerData[0].providerId;
      if (providerId == "apple.com") {
        _isFromApple = true;
      } else if (providerId == "google.com") {
        _isFromGoogle = true;
      }
    }

    _controllerName.text = authUser?.displayName ?? "";
    _controllerPhone.text = authUser?.phoneNumber ?? _controllerPhone.text;

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
    _controllerLocation.clear();
    _lat = null;
    _lng = null;
    _local = null;
    if (_controllerPhone.text.trim().isNotEmpty &&
    _local != null &&
    _lat != null &&
    _lng != null &&
    _controllerprofession.text.trim().isNotEmpty &&
    _agreeTerms &&
    _agreeContact) {
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
      appBar: GradientAppBar(
        leading: IconButton(
          onPressed: logout,
          icon: Icon(Icons.close),
        ),
        title: _traslation["title"],
        // shape: const ContinuousRectangleBorder(),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
          children: [
            if (_profisionSelected != null)
              CustomInput(
                label: _profisionSelected?.classOrder ?? "",
                controller: _controllerRegisterNumber,
                requiredField: true,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  isComplete(value);

                  // 🔍 busca pré-cadastro quando CRM tiver tamanho mínimo
                  if (value.trim().length >= 5) {
                   _loadPreRegisterByCrm(value.trim());
                  }
                },
              ),
               if (!_isFromApple)
              CustomInput(
                label: _traslation["name"],
                controller: _controllerName,
                requiredField: true,
                onChanged: isComplete,
              ),
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
           if (!_isSocialLogin) ...[
  CustomInput(
    label: _traslation["email"],
    controller: _controllerEmail,
    validator: ValidatorUtil.validateEmail,
    requiredField: true,
    onChanged: isComplete,
    textCapitalization: TextCapitalization.none,
  ),
  if (!_updateUser)
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
        onPressed: () => setState(() => _obscureText = !_obscureText),
      ),
    ),
  if (!_updateUser)
    CustomInput(
      label: _traslation["pass_repeat"],
      obscureText: _obscureText,
      controller: _controllerConfirmPassword,
      validator: (value) => ValidatorUtil.validateConfirmPassword(
          _controllerPassword.text, value),
      requiredField: true,
      onFieldSubmitted: (_) => _submitForm(),
      textCapitalization: TextCapitalization.none,
      onChanged: isComplete,
      suffixIcon: ViewPassIcon(
        obscureText: _obscureText,
        onPressed: () => setState(() => _obscureText = !_obscureText),
      ),
    ),
],
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

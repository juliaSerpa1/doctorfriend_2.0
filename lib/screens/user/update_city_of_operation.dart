import 'package:doctorfriend/components/input_location_sugest.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/services/users/users_service.dart';
import 'package:flutter/material.dart';
import 'package:doctorfriend/components/callback.dart';
import 'package:doctorfriend/components/loading_indicator.dart';
import 'package:doctorfriend/exeption/firebase_auth_handle_exception.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:go_router/go_router.dart';

class UpdateCityOfOperation extends StatefulWidget {
  const UpdateCityOfOperation({super.key});

  @override
  State<UpdateCityOfOperation> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<UpdateCityOfOperation> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  double? _lat;
  double? _lng;
  String? _local;
  final TextEditingController _controllerLocation = TextEditingController();

  late Map<String, dynamic> _traslation;
  final _user = AuthService().currentUser;
  Future<void> _handleSignup() async {
    setState(() => _loading = true);
    try {
      UsersService().updateCityOfOperation(
        userId: _user!.id,
        local: _local!,
        latitude: _lat!,
        longitude: _lng!,
      );
      Callback.snackBar(context, error: false);
      context.pop(true);
    } on FirebaseAuthHandleException catch (error) {
      Callback.snackBar(context, title: error.message);
      setState(() => _loading = false);
    } catch (error) {
      Callback.snackBar(context);
      setState(() => _loading = false);
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

  _setLatLng(String lat, String lng) {
    //garate que tem uma localização
    try {
      _lat = double.parse(lat);
      _lng = double.parse(lng);
      _local = _controllerLocation.text;
      setState(() {});
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    _controllerLocation.text = _user?.addresses[0].local ?? "";
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _traslation =
        Translations.of(context).translate('update_city_of_operation');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              label: _traslation["label"],
              requiredField: true,
              setLatLng: _setLatLng,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 55),
              child: ElevatedButton(
                onPressed: _loading || _lat == null || _lng == null
                    ? null
                    : _submitForm,
                child: LoadingIndicator(
                  loading: _loading,
                  child: Text(_traslation["save"]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:doctorfriend/components/input_location_sugest.dart';
import 'package:doctorfriend/components/location_input.dart';
import 'package:doctorfriend/exeption/firestore_exception.dart';
import 'package:doctorfriend/models/address_data.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/models/coordinates.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/services/users/users_service.dart';
import 'package:doctorfriend/utils/address_by_cep_util.dart';
import 'package:doctorfriend/utils/validator_util.dart';
import 'package:flutter/material.dart';
import 'package:doctorfriend/components/callback.dart';
import 'package:doctorfriend/components/custom_input.dart';
import 'package:doctorfriend/components/loading_indicator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UpdateAddressScreen extends StatefulWidget {
  final AddressData address;
  const UpdateAddressScreen({
    super.key,
    required this.address,
  });

  @override
  State<UpdateAddressScreen> createState() => _UpdateAddressScreenState();
}

class _UpdateAddressScreenState extends State<UpdateAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  late Map<String, dynamic> _traslation;

  double? _latitude;
  double? _longitude;

  double? _lat;
  double? _lng;
  String? _local;

  final TextEditingController _controllerStreet = TextEditingController();
  final TextEditingController _controllerNumber = TextEditingController();
  final TextEditingController _controllerNeighborhood = TextEditingController();
  // final TextEditingController _controllerCity = TextEditingController();
  // final TextEditingController _controllerState = TextEditingController();
  final TextEditingController _controllerComplement = TextEditingController();
  final TextEditingController _controllerZipeCode = TextEditingController();
  // final TextEditingController _controllerCountry = TextEditingController();
  final TextEditingController _controllerLocation = TextEditingController();

  Future<void> _handleSave() async {
    setState(() => _loading = true);
    try {
      final AppUser user = AuthService().currentUser!;
      await UsersService().updateUserAddresses(
        address: AddressData(
          id: widget.address.id,
          userId: user.id,
          street: _controllerStreet.text,
          number: int.tryParse(_controllerNumber.text),
          // city: _controllerCity.text,
          // state: _controllerState.text,
          complement: _controllerComplement.text,
          zipCode: _controllerZipeCode.text,
          neighborhood: _controllerNeighborhood.text,
          coordinates: _latitude != null && _longitude != null
              ? Coordinates(lat: _latitude!, lng: _longitude!)
              : null,
          lat: _lat ?? 0,
          lng: _lng ?? 0,
          local: _local ?? "",
          // country: _controllerCountry.text,
        ),
      );
      await AuthService().loadAddresses();
      Navigator.of(context).pop();
    } on FirestoreException catch (error) {
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
    if (_lat == null || _lng == null || _local == null) {
      //garate que tem uma localização
      return Callback.snackBar(context, title: _traslation["no_lat_lng"]);
    }
    _formKey.currentState?.save();
    _handleSave();
  }

  Future<void> _onCepChanged(String cep) async {
    try {
      final String? valid = ValidatorUtil.validateCEP(cep);

      if (valid == null) {
        final address = await AddressByCepUtil.getAddressFromCEP(cep);
        if (address != null) {
          if (address.street != "") {
            _controllerStreet.text = address.street;
          }
          if (address.neighborhood != "") {
            _controllerNeighborhood.text = address.neighborhood;
          }
          // if (address.city != "") {
          //   _controllerCity.text = address.city;
          // }
          // if (address.state != "") {
          //   _controllerState.text = address.state;
          // }
        }
      }
    } catch (error) {}
  }

  _setLatLng(String lat, String lng) {
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

  @override
  void initState() {
    super.initState();

    AddressData address = widget.address;
    _controllerStreet.text = address.street ?? "";
    _controllerNumber.text = address.number?.toString() ?? "";
    _controllerNeighborhood.text = address.neighborhood ?? "";
    // _controllerCity.text = address.city ?? "";
    // _controllerState.text = address.state ?? "";
    _controllerComplement.text = address.complement ?? "";
    _controllerZipeCode.text = address.zipCode ?? "";
    _controllerLocation.text = address.local;
    _longitude = address.coordinates?.lng;
    _latitude = address.coordinates?.lat;
    _lat = address.lat;
    _lng = address.lng;
    _local = address.local;
    // _controllerCountry.text = address.country ?? "";
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _traslation = Translations.of(context).translate('update_address_screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_traslation["title"])),
      body: Builder(builder: (context) {
        return Form(
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
              CustomInput(
                label: _traslation["zipe_code"],
                controller: _controllerZipeCode,
                onChanged: _onCepChanged,
                keyboardType: TextInputType.number,
              ),
              CustomInput(
                label: _traslation["street"],
                controller: _controllerStreet,
                requiredField: true,
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: CustomInput(
                        label: _traslation["number"],
                        controller: _controllerNumber,
                        requiredField: true,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: CustomInput(
                      label: _traslation["neighborhood"],
                      controller: _controllerNeighborhood,
                      requiredField: true,
                    ),
                  ),
                ],
              ),
              CustomInput(
                label: _traslation["complement"],
                controller: _controllerComplement,
                textCapitalization: TextCapitalization.sentences,
              ),
              // CustomInput(
              //   label: _traslation["city"],
              //   controller: _controllerCity,
              //   requiredField: true,
              // ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: CustomInput(
              //         label: _traslation["state"],
              //         controller: _controllerState,
              //         textCapitalization: TextCapitalization.sentences,
              //         requiredField: true,
              //       ),
              //     ),
              //     Expanded(
              //       child: Padding(
              //         padding: const EdgeInsets.only(left: 5),
              //         child: CustomInput(
              //           label: _traslation["country"],
              //           controller: _controllerCountry,
              //           textCapitalization: TextCapitalization.sentences,
              //           requiredField: true,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 10),
              LocationInput(
                (LatLng latLang) async {
                  _longitude = latLang.longitude;
                  _latitude = latLang.latitude;
                },
                latLngSelected: _longitude == null
                    ? null
                    : LatLng(_latitude ?? 0.0, _longitude ?? 0.0),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: ElevatedButton(
                  onPressed: _loading ? null : _submitForm,
                  child: LoadingIndicator(
                    loading: _loading,
                    child: Text(_traslation["save"]),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

import 'package:doctorfriend/components/callback.dart';
import 'package:doctorfriend/components/custom_input.dart';
import 'package:doctorfriend/components/loading_indicator.dart';
import 'package:doctorfriend/exeption/firestore_exception.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/services/users/users_service.dart';
import 'package:flutter/material.dart';

class UpdateContact extends StatefulWidget {
  final String phone;
  final String? phoneComercial;
  final String? registerNumber;
  final String? pix;
  final String? registerClassOrder;
  const UpdateContact({
    super.key,
    required this.phone,
    required this.phoneComercial,
    required this.registerNumber,
    required this.pix,
    required this.registerClassOrder,
  });

  @override
  State<UpdateContact> createState() => _UpdateContactState();
}

class _UpdateContactState extends State<UpdateContact> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerCommercialPhone =
      TextEditingController();
  final TextEditingController _controllerRegisterNumber =
      TextEditingController();
  final TextEditingController _controllerPix = TextEditingController();

  void _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();
    _handleSave();
  }

  Future<void> _handleSave() async {
    setState(() => _loading = true);
    try {
      final AppUser user = AuthService().currentUser!;
      await UsersService().updateUserContact(
        userId: user.id,
        phone: _controllerPhone.text,
        commercialPhone: _controllerCommercialPhone.text,
        registerNumber: _controllerRegisterNumber.text,
        pix: _controllerPix.text,
      );
    } on FirestoreException catch (error) {
      Callback.snackBar(context, title: error.message);
    } catch (error) {
      Callback.snackBar(context);
    }
    Navigator.of(context).pop();
    setState(() => _loading = false);
  }

  @override
  void initState() {
    super.initState();
    _controllerPhone.text = widget.phone;
    _controllerCommercialPhone.text = widget.phoneComercial ?? "";
    _controllerRegisterNumber.text = widget.registerNumber ?? "";
    _controllerPix.text = widget.pix ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final traslation = Translations.of(context).translate('update_contact');
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Text(
                traslation["title"],
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            CustomInput(
              label: traslation["phone"],
              controller: _controllerPhone,
              requiredField: true,
              keyboardType: TextInputType.phone,
            ),
            CustomInput(
              label: traslation["commercial_phone"],
              controller: _controllerCommercialPhone,
              keyboardType: TextInputType.phone,
            ),
            CustomInput(
              label: widget.registerClassOrder ?? traslation["crm"],
              controller: _controllerRegisterNumber,
            ),
            CustomInput(
              label: traslation["pix"],
              controller: _controllerPix,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                onPressed: _loading ? null : _submitForm,
                child: LoadingIndicator(
                  loading: _loading,
                  child: Text(traslation["save"]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

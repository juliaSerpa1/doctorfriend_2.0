import 'package:doctorfriend/components/callback.dart';
import 'package:doctorfriend/components/custom_input.dart';
import 'package:doctorfriend/components/loading_indicator.dart';
import 'package:doctorfriend/exeption/firestore_exception.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/services/users/users_service.dart';
import 'package:flutter/material.dart';

class UpdateDiseasesTreated extends StatefulWidget {
  final List<String> services;
  const UpdateDiseasesTreated({
    super.key,
    required this.services,
  });

  @override
  State<UpdateDiseasesTreated> createState() => _UpdateContactState();
}

class _UpdateContactState extends State<UpdateDiseasesTreated> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  late Map<String, dynamic> _diseasesTreated = {};

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
      List<String> diseasesTreated = [];
      _diseasesTreated.forEach((key, value) {
        diseasesTreated.add(value);
      });
      final AppUser user = AuthService().currentUser!;
      await UsersService().updateUserDiseasesTreated(
        userId: user.id,
        diseasesTreated: diseasesTreated,
      );
    } on FirestoreException catch (error) {
      Callback.snackBar(context, title: error.message);
    } catch (error) {
      Callback.snackBar(context);
    }
    Navigator.of(context).pop();
    setState(() => _loading = false);
  }

  _addFiel() {
    _diseasesTreated.putIfAbsent(_diseasesTreated.length.toString(), () => "");
    setState(() {});
  }

  _removeFiel(String objectKey) async {
    setState(() => _loading = true);

    final services = {..._diseasesTreated};
    services.removeWhere((key, value) => objectKey == key);
    _diseasesTreated.clear();
    List<String> servicesList = [];
    services.forEach((key, value) {
      servicesList.add(value);
    });
    for (int i = 0; i < servicesList.length; i++) {
      _diseasesTreated.putIfAbsent(i.toString(), () => servicesList[i]);
    }
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() => _loading = false);
  }

  @override
  void initState() {
    super.initState();
    final services = widget.services;
    if (services.isNotEmpty) {
      for (int i = 0; i < services.length; i++) {
        _diseasesTreated.putIfAbsent(i.toString(), () => services[i]);
      }
    } else {
      _diseasesTreated = {"0": ""};
    }
  }

  @override
  Widget build(BuildContext context) {
    final traslation =
        Translations.of(context).translate('update_diseases_treated');
    List<Widget> inputs() {
      final List<Widget> res = [];
      _diseasesTreated.forEach((key, value) {
        res.add(Stack(
          children: [
            if (!_loading)
              CustomInput(
                formData: _diseasesTreated,
                objectKey: key,
                onChanged: (val) => _diseasesTreated[key] = val,
                label: "(${int.parse(key) + 1})",
              )
            else
              const SizedBox(height: 60),
            Positioned(
              right: 5,
              top: 15,
              child: IconButton(
                onPressed: () => _removeFiel(key),
                icon: Icon(
                  Icons.remove_circle,
                  size: 25,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          ],
        ));
      });

      return res;
    }

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
            ...inputs(),
            IconButton(
              onPressed: _addFiel,
              icon: Icon(
                Icons.add_box_rounded,
                size: 33,
                color: Theme.of(context).colorScheme.primary,
              ),
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

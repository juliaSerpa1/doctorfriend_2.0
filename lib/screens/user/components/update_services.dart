import 'package:doctorfriend/components/callback.dart';
import 'package:doctorfriend/components/custom_input.dart';
import 'package:doctorfriend/components/loading_indicator.dart';
import 'package:doctorfriend/exeption/firestore_exception.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/models/user_service.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/services/users/users_service.dart';
import 'package:flutter/material.dart';

class UpdateServices extends StatefulWidget {
  final List<UserService> services;
  const UpdateServices({
    super.key,
    required this.services,
  });

  @override
  State<UpdateServices> createState() => _UpdateContactState();
}

class _UpdateContactState extends State<UpdateServices> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  late Map<String, dynamic> _services = {};

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
      List<UserService> servicesList = [];
      _services.forEach((key, value) {
        final hasPrice = value["price"].trim() != "";
        final String price = hasPrice ? value["price"] : "";
        servicesList.add(
          UserService(
              service: value["service"],
              price: price,
              priceFixed: value["priceFixed"]),
        );
      });
      final AppUser user = AuthService().currentUser!;
      await UsersService().updateUserServices(
        userId: user.id,
        services: servicesList,
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
    _services.putIfAbsent(
      _services.length.toString(),
      () => {
        "service": "",
        "price": "",
        "priceFixed": true,
      },
    );
    setState(() {});
  }

  _removeFiel(String objectKey) async {
    setState(() => _loading = true);

    final services = {..._services};
    services.removeWhere((key, value) => objectKey == key);
    _services.clear();
    List<Map<String, dynamic>> servicesList = [];
    services.forEach((key, value) {
      servicesList.add(value);
    });
    for (int i = 0; i < servicesList.length; i++) {
      _services.putIfAbsent(
          i.toString(),
          () => {
                "service": servicesList[i]["service"],
                "price": servicesList[i]["price"],
                "priceFixed": servicesList[i]["priceFixed"],
              });
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
        if (services[i].service.trim() == "") {
          continue;
        }
        _services.putIfAbsent(
          i.toString(),
          () => {
            "service": services[i].service,
            "price": services[i].price == null ? "" : services[i].price!,
            "priceFixed": services[i].priceFixed,
          },
        );
      }
    } else {
      _services = {
        "0": {
          "service": "",
          "price": "",
          "priceFixed": true,
        }
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final traslation = Translations.of(context).translate('update_services');
    List<Widget> inputs() {
      final List<Widget> res = [];
      _services.forEach((key, value) {
        res.add(Stack(
          children: [
            if (!_loading)
              Column(
                children: [
                  CustomInput(
                    formData: _services[key],
                    objectKey: "service",
                    onChanged: (val) => _services[key]["service"] = val,
                    label: traslation["service"]
                        .replaceAll("{amount}", "${int.parse(key) + 1}"),
                  ),
                  CustomInput(
                    formData: _services[key],
                    objectKey: "price",
                    onChanged: (val) => _services[key]["price"] = val,
                    label: traslation["price"],
                    keyboardType: TextInputType.streetAddress,
                  ),
                  // CustomCheckbox(
                  //   label: Padding(
                  //     padding: const EdgeInsets.only(top: 8.0),
                  //     child: Text(
                  //       "Preço Fixo",
                  //       style: Theme.of(context).textTheme.bodySmall,
                  //     ),
                  //   ),
                  //   onChanged: (boo) {
                  //     setState(
                  //         () => _services[key]["priceFixed"] = boo ?? false);
                  //   },
                  //   value: _services[key]["priceFixed"],
                  // ),
                  const Divider(),
                ],
              )
            else
              const SizedBox(height: 170),
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

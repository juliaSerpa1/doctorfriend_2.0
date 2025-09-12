import 'package:doctorfriend/components/callback.dart';
import 'package:doctorfriend/components/custom_input.dart';
import 'package:doctorfriend/components/loading_indicator.dart';
import 'package:doctorfriend/exeption/firestore_exception.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/services/users/users_service.dart';
import 'package:flutter/material.dart';

class UpdateLinks extends StatefulWidget {
  final String site;
  final String? facebook;
  final String? instagram;
  final String? twitter;
  const UpdateLinks({
    super.key,
    required this.site,
    required this.facebook,
    required this.instagram,
    required this.twitter,
  });

  @override
  State<UpdateLinks> createState() => _UpdateLinksState();
}

class _UpdateLinksState extends State<UpdateLinks> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  final TextEditingController _controllerSite = TextEditingController();
  final TextEditingController _controllerFacebook = TextEditingController();
  final TextEditingController _controllerInstagram = TextEditingController();
  final TextEditingController _controllerTwitter = TextEditingController();

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
      await UsersService().updateUserLinks(
        userId: user.id,
        site: _controllerSite.text,
        facebook: _controllerFacebook.text,
        instagram: _controllerInstagram.text,
        twitter: _controllerTwitter.text,
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
    _controllerSite.text = widget.site;
    _controllerFacebook.text = widget.facebook ?? "";
    _controllerInstagram.text = widget.instagram ?? "";
    _controllerTwitter.text = widget.twitter ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final traslation = Translations.of(context).translate('update_links');
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
              label: traslation["site"],
              controller: _controllerSite,
              keyboardType: TextInputType.url,
              textCapitalization: TextCapitalization.none,
            ),
            CustomInput(
              label: traslation["facebook"],
              controller: _controllerFacebook,
              keyboardType: TextInputType.url,
              textCapitalization: TextCapitalization.none,
            ),
            CustomInput(
              label: traslation["instagram"],
              controller: _controllerInstagram,
              keyboardType: TextInputType.url,
              textCapitalization: TextCapitalization.none,
            ),
            CustomInput(
              label: traslation["twitter"],
              controller: _controllerTwitter,
              keyboardType: TextInputType.url,
              textCapitalization: TextCapitalization.none,
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

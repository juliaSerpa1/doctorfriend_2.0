import 'package:doctorfriend/components/callback.dart';
import 'package:doctorfriend/components/input_select.dart';
import 'package:doctorfriend/components/loading_indicator.dart';
import 'package:doctorfriend/exeption/firestore_exception.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/services/users/users_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

class UpdateTimeZone extends StatefulWidget {
  final String timeZone;
  const UpdateTimeZone({
    super.key,
    required this.timeZone,
  });

  @override
  State<UpdateTimeZone> createState() => _UpdateTimeZoneState();
}

class _UpdateTimeZoneState extends State<UpdateTimeZone> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  List<String> _timeZones = [];
  int _selectedTimezone = 0;
  final TextEditingController _controllerTimeZone = TextEditingController();

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
      await UsersService().updateUserTimeZone(
        userId: user.id,
        timeZone: _controllerTimeZone.text,
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
    _controllerTimeZone.text = widget.timeZone;
    _getTimezones();
  }

  _getTimezones() async {
    setState(() {
      _loading = true;
    });
    _timeZones = await FlutterTimezone.getAvailableTimezones();
    _timeZones.sort();
    _selectedTimezone =
        _timeZones.indexWhere((element) => widget.timeZone == element);
    _loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> services() {
      final list = _timeZones.map((val) => Text(val)).toList();
      if (list.isEmpty) {
        list.add(const Text(""));
      }
      return list;
    }

    final traslation = Translations.of(context).translate('update_time_zone');
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
            if (!_loading)
              InputSelect(
                data: services(),
                selectedIndex: _selectedTimezone,
                onChanged: (index) {
                  if (index < _timeZones.length) {
                    setState(() {
                      _selectedTimezone = index;
                    });
                  }
                },
                label: traslation["label"],
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

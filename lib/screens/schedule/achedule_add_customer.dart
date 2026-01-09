import 'package:doctorfriend/components/app_image.dart';
import 'package:doctorfriend/components/callback.dart';
import 'package:doctorfriend/components/custom_input.dart';
import 'package:doctorfriend/components/input_select.dart';
import 'package:doctorfriend/components/loading_indicator.dart';
import 'package:doctorfriend/exeption/firestore_exception.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/models/schedule_time_of_day.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:doctorfriend/services/schedule/schedule_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/utils/formater_util.dart';
import 'package:doctorfriend/utils/validator_util.dart';
import 'package:flutter/material.dart';
import 'package:doctorfriend/components/gradient_app_bar.dart';

class ScheduleAddCustomer extends StatefulWidget {
  final ScheduletimeOfDay scheduletimeOfDay;
  const ScheduleAddCustomer({
    super.key,
    required this.scheduletimeOfDay,
  });

  @override
  State<ScheduleAddCustomer> createState() => _ScheduleAddCustomerState();
}

class _ScheduleAddCustomerState extends State<ScheduleAddCustomer> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  late ScheduletimeOfDay _scheduletimeOfDay;
  int _visiteTypeIndex = 0;
  final AppUser _user = AuthService().currentUser!;
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerNote = TextEditingController();
  bool _isTelemedicine = false;
  late Map<String, dynamic> _traslation;
  late List<String> _daysOfWeek;
  late List<String> _montsOfYear;

  late String _today;

  Future<void> _handleSave() async {
    setState(() => _loading = true);
    try {
      await ScheduleService().addScheduleDay(
        scheduletimeOfDay: ScheduletimeOfDay(
          userId: _user.id,
          timeOfDay: _scheduletimeOfDay.timeOfDay,
          customerId: null,
          customerName: _controllerName.text,
          customerPhone: _controllerPhone.text,
          customerEmail: _controllerEmail.text,
          customerNote: _controllerNote.text,
          updatedByUser: _user.id,
          customerService: _user.services.isNotEmpty
              ? _user.services[_visiteTypeIndex].string
              : null,
          updatedDate: DateTime.now(),
          createdDate: null,
          isTelemedicine: _isTelemedicine,
        ),
      );
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
    _formKey.currentState?.save();
    _handleSave();
  }

  @override
  void initState() {
    super.initState();
    _scheduletimeOfDay = widget.scheduletimeOfDay;
    _controllerName.text = _scheduletimeOfDay.customerName ?? "";
    _controllerPhone.text = _scheduletimeOfDay.customerPhone ?? "";
    _controllerEmail.text = _scheduletimeOfDay.customerEmail ?? "";
    _controllerNote.text = _scheduletimeOfDay.customerService ?? "";
    _isTelemedicine = _scheduletimeOfDay.isTelemedicine;
    // _visiteTypeIndex = _user.services.indexWhere(
    //     (element) => element.string == _scheduletimeOfDay.customerService);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final traslationContext = Translations.of(context);
    _traslation = traslationContext.translate('add_schedule');
    _today = traslationContext.translate('today')["text"];
    _montsOfYear =
        traslationContext.translate('months_of_year')["list"].cast<String>();
    _daysOfWeek =
        traslationContext.translate('days_of_week')["list"].cast<String>();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> services() {
      final list = _user.services.map((e) => Text(e.string)).toList();
      // list.add(const Text(""));
      return list;
    }

    final theme = Theme.of(context);
    return Scaffold(
      appBar: GradientAppBar(title: _traslation["title"]),
      body: Builder(builder: (context) {
        return Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.only(
              left: 15.0,
              right: 15.0,
              bottom: 20.0,
            ),
            children: [
              ListTile(
                title: Text(_user.name),
                subtitle: Text(_user.getProfession?.name ?? ""),
                leading: AppImage(
                  imageUrl: _user.imageUrl,
                  isCircular: true,
                ),
              ),
              if (!_isTelemedicine)
                ListTile(
                  title: Text(
                    _user.addresses[0].addressString,
                    style: theme.textTheme.titleSmall,
                  ),
                  leading: Icon(
                    Icons.location_on_outlined,
                    color: theme.colorScheme.primary,
                  ),
                )
              else
                ListTile(
                  title: Text(
                    _traslation["telemedicine_worn"],
                    style: theme.textTheme.titleSmall,
                  ),
                  leading: Icon(
                    Icons.videocam_outlined,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ListTile(
                title: Text(
                  FormaterUtil.formatDateTextFull(
                    date: _scheduletimeOfDay.timeOfDay,
                    daysOfWeek: _daysOfWeek,
                    montsOfYear: _montsOfYear,
                    today: _today,
                  ),
                  style: theme.textTheme.titleSmall,
                ),
                leading: Icon(
                  Icons.calendar_month_outlined,
                  color: theme.colorScheme.primary,
                ),
              ),
              // TelemedicineSchedule(
              //   isTelemedicine: _isTelemedicine,
              //   onChanged: (booleam) =>
              //       setState(() => _isTelemedicine = booleam ?? false),
              // ),
              const Divider(),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    _traslation["schedule_for"],
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ),
              CustomInput(
                label: _traslation["name"],
                controller: _controllerName,
                requiredField: true,
              ),
              CustomInput(
                label: _traslation["phone"],
                controller: _controllerPhone,
                requiredField: true,
                keyboardType: TextInputType.number,
              ),
              CustomInput(
                label: _traslation["email"],
                controller: _controllerEmail,
                textCapitalization: TextCapitalization.none,
                validator: ValidatorUtil.validateEmail,
              ),
              InputSelect(
                data: services(),
                selectedIndex: _visiteTypeIndex,
                onChanged: (index) {
                  if (index < _user.services.length) {
                    setState(() {
                      _visiteTypeIndex = index;
                    });
                  } else {}
                },
                label: _traslation["visit_type"],
              ),
              CustomInput(
                label: _traslation["note"],
                controller: _controllerNote,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: ElevatedButton(
                  onPressed: _loading ? null : _submitForm,
                  child: LoadingIndicator(
                    loading: _loading,
                    child: Text(_traslation["btn_schedule"]),
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

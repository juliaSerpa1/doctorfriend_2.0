import 'dart:async';

import 'package:doctorfriend/components/app_image.dart';
import 'package:doctorfriend/components/callback.dart';
import 'package:doctorfriend/components/floating_button.dart';
import 'package:doctorfriend/components/loading_indicator.dart';
import 'package:doctorfriend/components/modal.dart';
import 'package:doctorfriend/components/row_text.dart';
import 'package:doctorfriend/exeption/firestore_exception.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/models/schedule_time_of_day.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:doctorfriend/services/email/email_service.dart';
import 'package:doctorfriend/services/schedule/schedule_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/utils/app_routes_util.dart';
import 'package:doctorfriend/utils/formater_util.dart';
import 'package:doctorfriend/utils/tools_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScheduleCustomer extends StatefulWidget {
  final ScheduletimeOfDay scheduletimeOfDay;
  final bool canceled;
  const ScheduleCustomer({
    super.key,
    required this.scheduletimeOfDay,
    this.canceled = false,
  });

  @override
  State<ScheduleCustomer> createState() => _ScheduleCustomerState();
}

class _ScheduleCustomerState extends State<ScheduleCustomer> {
  AppUser _user = AuthService().currentUser!;
  late bool _notified;

  bool _loading = false;
  bool _loadingEmail = false;
  String _statusEmail = "";
  late ScheduletimeOfDay _scheduletimeOfDay;

  late String _notifiedText;
  late Translations _traslationContext;
  late Map<String, dynamic> _traslation;
  late List<String> _daysOfWeek;
  late List<String> _montsOfYear;

  late String _today;

  Future<void> _handleDelete() async {
    final res = await Callback.confirm(
      context: context,
      content:
          "${_traslation["delete_schedule"]} ${FormaterUtil.formatDateTextFull(
        date: _scheduletimeOfDay.timeOfDay,
        daysOfWeek: _daysOfWeek,
        montsOfYear: _montsOfYear,
        today: _today,
      )}?",
    );
    if (!res) return;
    setState(() => _loading = true);
    try {
      await ScheduleService().addScheduleDay(
        scheduletimeOfDay: ScheduletimeOfDay(
          userId: _user.id,
          timeOfDay: _scheduletimeOfDay.timeOfDay,
          customerId: null,
          customerName: null,
          customerPhone: null,
          customerEmail: null,
          customerNote: null,
          customerService: null,
          updatedDate: null,
          createdDate: null,
          confirmed: false,
          notificationId: null,
          finished: false,
          updatedByUser: _user.id,
          isTelemedicine: _scheduletimeOfDay.isTelemedicine,
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

  StreamSubscription<Map<String, dynamic>?>? _emailSenderListner;

  _sendEmailRemainder() async {
    final res = await Callback.confirm(
        context: context,
        content:
            "${_traslation["send_email_confirm"]}'${_scheduletimeOfDay.customerName ?? ""}'?");

    if (!res) return;
    try {
      setState(() => _loadingEmail = true);
      Modal.showLoading(context, canPop: false);
      final listener = await EmailService().sendRemaiderEmail(
        scheduletimeOfDay: _scheduletimeOfDay,
        user: _user,
        traslationContext: _traslationContext,
      );

      _emailSenderListner = listener.listen((event) {
        final data = event;
        if (data?["stateCode"] == 1) {
          setState(
              () => _statusEmail = _traslation["send_email_is_proccessing"]);
        } else if (data?["stateCode"] == 3) {
          _loadingEmail = false;
          setState(() => _statusEmail = _traslation["send_email_error"]);
          Callback.snackBar(context, title: _traslation["send_email_error"]);
          Navigator.of(context, rootNavigator: true).pop();
        } else if (data?["stateCode"] == 2) {
          setState(() => _statusEmail = _traslation["send_email_pendding"]);
        } else if (data?["stateCode"] == 0) {
          _notified = true;
          setState(() => _statusEmail = _notifiedText);
          Navigator.of(context, rootNavigator: true).pop();
        }
      });
    } on FirestoreException catch (error) {
      Callback.snackBar(context, title: error.message);
      Navigator.of(context, rootNavigator: true).pop();
      setState(() => _loadingEmail = false);
    } catch (error) {
      Callback.snackBar(context);
      Navigator.of(context, rootNavigator: true).pop();
      setState(() => _loadingEmail = false);
    }
  }

  _openPremium() async {
    await context.push(AppRoutesUtil.premium);
    _user = AuthService().currentUser!;
    setState(() {});
  }

  @override
  void dispose() {
    _emailSenderListner?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scheduletimeOfDay = widget.scheduletimeOfDay;
    _notified = _scheduletimeOfDay.notificationId != null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _traslationContext = Translations.of(context);
    _traslation = _traslationContext.translate('scheduled_customer');
    _today = _traslationContext.translate('today')["text"];
    _montsOfYear =
        _traslationContext.translate('months_of_year')["list"].cast<String>();
    _daysOfWeek =
        _traslationContext.translate('days_of_week')["list"].cast<String>();
    _notifiedText = _traslation["notified_text"];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(_traslation["title"])),
      body: LoadingIndicator(
        loading: _loading,
        child: ListView(
          padding: const EdgeInsets.only(
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
            if (!_scheduletimeOfDay.isTelemedicine)
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
            const Divider(),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  widget.canceled
                      ? _traslation["status_canceled"]
                      : _traslation["status_scheduled"],
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: widget.canceled ? theme.colorScheme.error : null,
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text(_scheduletimeOfDay.customerName ?? ""),
              leading: const AppImage(
                imageUrl: "assets/images/avatar.png",
                isCircular: true,
              ),
            ),
            ListTile(
              title: InkWell(
                onTap: () => ToolsUtil.launchURL(
                  context,
                  urlString:
                      "https://wa.me/${_scheduletimeOfDay.customerPhone ?? ""}",
                ),
                child: Text(
                  _scheduletimeOfDay.customerPhone ?? "",
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              leading: Icon(
                Icons.phone_android,
                color: theme.colorScheme.primary,
              ),
            ),
            ListTile(
              title: InkWell(
                onTap: () => ToolsUtil.launchURL(
                  context,
                  urlString: "mailto:${_scheduletimeOfDay.customerEmail ?? ""}",
                ),
                child: Text(
                  _scheduletimeOfDay.customerEmail ?? "",
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              leading: Icon(
                Icons.email_outlined,
                color: theme.colorScheme.primary,
              ),
            ),
            ListTile(
              title: Text(
                _scheduletimeOfDay.customerService ?? "",
                style: theme.textTheme.titleSmall,
              ),
              leading: Icon(
                Icons.medical_services_outlined,
                color: theme.colorScheme.primary,
              ),
            ),
            if (_scheduletimeOfDay.updatedDate != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 15.0),
                child: RowText(
                  title: _traslation["confirmed"],
                  content: FormaterUtil.formatDateTextFull(
                    date: _scheduletimeOfDay.updatedDate!,
                    daysOfWeek: _daysOfWeek,
                    montsOfYear: _montsOfYear,
                    today: _today,
                  ),
                ),
              ),
            if (_scheduletimeOfDay.isAfter &&
                !widget.canceled &&
                _scheduletimeOfDay.customerEmail?.trim() != "")
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: _loadingEmail || _notified
                          ? null
                          : _user.isGold
                              ? _sendEmailRemainder
                              : _openPremium,
                      icon: Icon(
                        _notified
                            ? Icons.mark_email_read_outlined
                            : _user.isGold
                                ? Icons.mark_email_unread_outlined
                                : Icons.mail_lock_outlined,
                      ),
                      label: Text(
                        _notified
                            ? _notifiedText
                            : _loadingEmail
                                ? _statusEmail
                                : _traslation["send_email"],
                      ),
                    ),
                  ],
                ),
              ),
            ListTile(
              subtitle: Text(_scheduletimeOfDay.customerNote ?? ""),
              title: Text(_traslation["note"]),
            ),
          ],
        ),
      ),
      floatingActionButton: widget.canceled
          ? null
          : MultiFloatingButton(
              buttons: [
                MinFloatingButton(
                  onPressed: _handleDelete,
                  child: Icon(
                    Icons.delete,
                    color: theme.colorScheme.onError,
                  ),
                  color: theme.colorScheme.error,
                ),
                MinFloatingButton(
                  onPressed: () {},
                  child: const Icon(Icons.delete),
                  isMain: true,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
    );
  }
}

import 'package:doctorfriend/components/adaptative_date_picker.dart';
import 'package:doctorfriend/components/callback.dart';
import 'package:doctorfriend/components/modal.dart';
import 'package:doctorfriend/exeption/firestore_exception.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/models/schedule_time_of_day.dart';
import 'package:doctorfriend/screens/schedule/achedule_add_customer.dart';
import 'package:doctorfriend/screens/schedule/achedule_customer.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:doctorfriend/services/email/email_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/utils/app_routes_util.dart';
import 'package:doctorfriend/utils/formater_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DayCard extends StatefulWidget {
  final DateTime day;
  final List<ScheduletimeOfDay> scheduletimesOfDay;
  final Function(DateTime date) updateDate;
  final bool loading;
  final bool isNotRegistered;
  const DayCard({
    super.key,
    required this.day,
    required this.updateDate,
    required this.scheduletimesOfDay,
    required this.loading,
    required this.isNotRegistered,
  });

  @override
  State<DayCard> createState() => _DayCardState();
}

class _DayCardState extends State<DayCard> {
  late Translations _traslationContext;
  late Map<String, dynamic> _traslation;
  late List<String> _daysOfWeek;
  late List<String> _montsOfYear;
  AppUser _user = AuthService().currentUser!;
  late String _today;

  _sendEmailRemainder() async {
    final res = await Callback.confirm(
        context: context,
        content:
            "${_traslation["confirm_send_email"]}  ${(FormaterUtil.formatDate(widget.day))}?");

    if (!res) return;
    try {
      for (final scheduletime in widget.scheduletimesOfDay) {
        if (scheduletime.notificationId != null ||
            !scheduletime.isSchedule ||
            !scheduletime.isAfter) {
          continue;
        }
        Modal.showLoading(context, canPop: false);
        final listener = await EmailService().sendRemaiderEmail(
          scheduletimeOfDay: scheduletime,
          user: _user,
          traslationContext: _traslationContext,
        );

        listener.listen((event) {
          final data = event;
          if (data?["stateCode"] == 1) {
            // setState(() => _statusEmail = "Processando...");
          } else if (data?["stateCode"] == 3) {
            // _loadingEmail = false;
            // setState(() => _statusEmail = "Error ao enviar ;(");
            Navigator.of(context, rootNavigator: true).pop();
          } else if (data?["stateCode"] == 2) {
            // setState(() => _statusEmail = "Pendente");
          } else if (data?["stateCode"] == 0) {
            Navigator.of(context, rootNavigator: true).pop();
          }
        });
      }
    } on FirestoreException catch (error) {
      Callback.snackBar(context, title: error.message);
      Navigator.of(context, rootNavigator: true).pop();
    } catch (error) {
      Callback.snackBar(context);
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  bool _canSendEmail() {
    for (final scheduletime in widget.scheduletimesOfDay) {
      if (scheduletime.notificationId != null ||
          !scheduletime.isSchedule ||
          !scheduletime.isAfter) {
        continue;
      }
      return true;
    }
    return false;
  }

  _openPremium() async {
    await context.push(AppRoutesUtil.premium);
    _user = AuthService().currentUser!;
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _traslationContext = Translations.of(context);
    _traslation = _traslationContext.translate('schedule_day_card');
    _today = _traslationContext.translate('today')["text"];
    _montsOfYear =
        _traslationContext.translate('months_of_year')["list"].cast<String>();

    _daysOfWeek =
        _traslationContext.translate('days_of_week')["list"].cast<String>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.tertiary,
          width: .5,
        ),
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  FormaterUtil.capitalize(
                    FormaterUtil.formatDateText(
                      widget.day,
                      _daysOfWeek,
                      _today,
                    ),
                  ),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: AdaptativeDatePicker(
                    initialDate: widget.day,
                    onDateChanged: widget.updateDate,
                  ),
                ),
                if (_canSendEmail())
                  Positioned(
                    right: 0,
                    top: 0,
                    child: PopupMenuButton<String>(
                      iconColor: Theme.of(context).colorScheme.onPrimary,
                      itemBuilder: (BuildContext context) {
                        return <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            onTap: _user.isGold
                                ? _sendEmailRemainder
                                : _openPremium,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Icon(_user.isGold
                                      ? Icons.mail_outline
                                      : Icons.mail_lock_outlined),
                                ),
                                Expanded(
                                  child: Text(
                                    _traslation["send_email_for_all"],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ];
                      },
                    ),
                  ),
              ],
            ),
          ),
          if (widget.loading)
            LinearProgressIndicator(
              backgroundColor: Theme.of(context).colorScheme.secondary,
            )
          else
            const SizedBox(height: 15),
          Expanded(
            child: widget.scheduletimesOfDay.isEmpty &&
                    !widget.isNotRegistered &&
                    !widget.loading
                ? Center(
                    child: Text(_traslation["no_time_available"]),
                  )
                : widget.isNotRegistered && !widget.loading
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _traslation["schedule_not_registered"]?.replaceAll(
                                  '{text}',
                                  "${_montsOfYear[widget.day.month - 1]} ${widget.day.year}"),
                            ),
                            TextButton(
                              onPressed: () =>
                                  context.push(AppRoutesUtil.scheduleSettings),
                              child: Text(_traslation["register_schedule"]),
                            )
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: widget.scheduletimesOfDay.length,
                        itemBuilder: (ctx, index) {
                          final bool isMark =
                              widget.scheduletimesOfDay[index].isSchedule;

                          final scheduletimeOfDay =
                              widget.scheduletimesOfDay[index];
                          return TimeSingle(
                            isMark: isMark,
                            scheduletimeOfDay: scheduletimeOfDay,
                          );
                        },
                      ),
          )
        ],
      ),
    );
  }
}

class TimeSingle extends StatelessWidget {
  final ScheduletimeOfDay scheduletimeOfDay;
  const TimeSingle({
    super.key,
    required this.isMark,
    required this.scheduletimeOfDay,
  });

  final bool isMark;

  @override
  Widget build(BuildContext context) {
    addSchedule() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScheduleAddCustomer(
            scheduletimeOfDay: scheduletimeOfDay,
          ),
        ),
      );
    }

    goToSchedule() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScheduleCustomer(
            scheduletimeOfDay: scheduletimeOfDay,
          ),
        ),
      );
    }

    bool isAfter = scheduletimeOfDay.isAfter;

    final notified = scheduletimeOfDay.notificationId != null;
    final traslation = Translations.of(context).translate('schedule_day_card');
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.primary.withOpacity(.2),
          ),
        ),
      ),
      child: Opacity(
        opacity: isAfter ? 1 : .6,
        child: ListTile(
          onTap: !isAfter && !isMark
              ? null
              : isMark
                  ? goToSchedule
                  : addSchedule,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  isMark
                      ? FormaterUtil.capitalize(
                          scheduletimeOfDay.customerName ?? "")
                      : scheduletimeOfDay.timeOfDayString,
                  style: TextStyle(
                    decoration:
                        isAfter || isMark ? null : TextDecoration.lineThrough,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Row(
            children: [
              Icon(
                scheduletimeOfDay.isTelemedicine
                    ? Icons.videocam_outlined
                    : Icons.location_on_outlined,
                size: 18,
              ),
              const SizedBox(width: 5.0),
              Text(
                scheduletimeOfDay.isTelemedicine
                    ? traslation["telemedicine"]
                    : traslation["in_local"],
              ),
            ],
          ),
          // subtitle: isMark ? Text("20mn") : null,
          leading: isMark
              ? Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    scheduletimeOfDay.timeOfDayString,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          decoration:
                              isAfter ? null : TextDecoration.lineThrough,
                        ),
                  ),
                )
              : null,
          trailing: !isAfter && !isMark
              ? null
              : isMark
                  ? SizedBox(
                      width: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            notified
                                ? Icons.mark_email_read_outlined
                                : Icons.mark_email_unread_outlined,
                            size: 20,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          Icon(
                            Icons.person_pin_outlined,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    )
                  : Icon(
                      Icons.person_add,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
        ),
      ),
    );
  }
}

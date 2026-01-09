import 'package:doctorfriend/components/callback.dart';
import 'package:doctorfriend/data/store.dart';
import 'package:doctorfriend/exeption/handle_exception.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/models/schedule_time_of_day.dart';
import 'package:doctorfriend/models/schedule_week.dart';
import 'package:doctorfriend/screens/schedule/components/telemedicine.dart';
import 'package:doctorfriend/screens/schedule/components/time_of_day_box.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/utils/formater_util.dart';
import 'package:doctorfriend/utils/preferences_util.dart';
import 'package:flutter/material.dart';
import 'package:doctorfriend/components/gradient_app_bar.dart';

class ScheduleEditDays extends StatefulWidget {
  const ScheduleEditDays({
    super.key,
  });

  @override
  State<ScheduleEditDays> createState() => _ScheduleEditDaysState();
}

class _ScheduleEditDaysState extends State<ScheduleEditDays> {
  late ScheduleWeek _scheduleWeek;
  bool _isTelemedicine = false;
  final lang = Translations.currentLocale.languageCode;
  late Map<String, dynamic> _traslation;
  late Map<String, dynamic> _traslationMonth;
  late List<String> _daysOfWeek;
  final DateTime now = DateTime.now();
  AppUser user = AuthService().currentUser!;
  void _deleteOne(int day, DateTime timeOfDay) {
    try {
      _scheduleWeek.deleteOne(day, timeOfDay);
      setState(() {});
    } on HandleException catch (error) {
      Callback.snackBar(context, title: error.message);
    } catch (error) {
      Callback.snackBar(context);
    }
  }

  void _addOne(int day, TimeOfDay timeOfDay, [showExistsError = true]) {
    try {
      _scheduleWeek.add(
        day: day,
        time: DateTime(
            now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute),
        isTelemedicine: _isTelemedicine,
        userId: user.id,
        language: lang,
      );
      setState(() {});
    } on HandleException catch (error) {
      if (showExistsError) {
        Callback.snackBar(context, title: error.message);
      }
    } catch (error) {
      Callback.snackBar(context);
    }
  }

  Future<void> _handleSave() async {
    try {
      await Store.saveMap(PreferencesUtil.schedulePreferencesForWeek, {
        "0": _scheduleWeek.monday
            .map((e) => {
                  "hour": e.timeOfDay.hour,
                  "minute": e.timeOfDay.minute,
                  "isTelemedicine": e.isTelemedicine,
                })
            .toList(),
        "1": _scheduleWeek.tuesday
            .map((e) => {
                  "hour": e.timeOfDay.hour,
                  "minute": e.timeOfDay.minute,
                  "isTelemedicine": e.isTelemedicine,
                })
            .toList(),
        "2": _scheduleWeek.wednesday
            .map((e) => {
                  "hour": e.timeOfDay.hour,
                  "minute": e.timeOfDay.minute,
                  "isTelemedicine": e.isTelemedicine,
                })
            .toList(),
        "3": _scheduleWeek.thursday
            .map((e) => {
                  "hour": e.timeOfDay.hour,
                  "minute": e.timeOfDay.minute,
                  "isTelemedicine": e.isTelemedicine,
                })
            .toList(),
        "4": _scheduleWeek.friday
            .map((e) => {
                  "hour": e.timeOfDay.hour,
                  "minute": e.timeOfDay.minute,
                  "isTelemedicine": e.isTelemedicine,
                })
            .toList(),
        "5": _scheduleWeek.saturday
            .map((e) => {
                  "hour": e.timeOfDay.hour,
                  "minute": e.timeOfDay.minute,
                  "isTelemedicine": e.isTelemedicine,
                })
            .toList(),
        "6": _scheduleWeek.sunday
            .map((e) => {
                  "hour": e.timeOfDay.hour,
                  "minute": e.timeOfDay.minute,
                  "isTelemedicine": e.isTelemedicine,
                })
            .toList(),
      });
      Navigator.of(context).pop();
      Callback.snackBar(context, error: false);
    } catch (e) {
      Callback.snackBar(context, title: _traslation["error_on_save"]);
    }
  }

  Future<void> _storedItems() async {
    Map<String, dynamic> stored =
        await Store.getMap(PreferencesUtil.schedulePreferencesForWeek);
    stored.forEach((key, value) {
      for (final val in value) {
        _scheduleWeek.add(
          day: int.parse(key),
          time: DateTime(
            now.year,
            now.month,
            now.day,
            val["hour"],
            val["minute"],
          ),
          isTelemedicine: val["isTelemedicine"],
          userId: user.id,
          language: lang,
        );
      }
    });
    setState(() {});
  }

  void _duplicate(List<ScheduletimeOfDay> timesOfDay, int day) {
    if (timesOfDay.isEmpty) return;

    // Encontra o próximo dia
    int nextDay = day + 1;
    if (nextDay > _daysOfWeek.length) return;

    // Copia os horários para o próximo dia
    for (var schedule in timesOfDay) {
      _addOne(
          nextDay - 1,
          TimeOfDay(
            hour: schedule.timeOfDay.hour,
            minute: schedule.timeOfDay.minute,
          ),
          false);
    }
  }

  @override
  void initState() {
    super.initState();
    _scheduleWeek = ScheduleWeek();
    _storedItems();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final traslationContext = Translations.of(context);
    _traslation = traslationContext.translate('schedule_edit_days');
    _traslationMonth = traslationContext.translate('schedule_edit_month');
    _daysOfWeek =
        traslationContext.translate('days_of_week')["list"].cast<String>();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height - 325;
    return Scaffold(
      appBar: GradientAppBar(
        title: _traslation["title"],
      ),
      body: Column(
        children: [
          Telemedicine(
            isTelemedicine: _isTelemedicine,
            onChanged: (booleam) =>
                setState(() => _isTelemedicine = booleam ?? false),
          ),
          SizedBox(
            width: double.infinity,
            height: height,
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 20.0),
              scrollDirection: Axis.horizontal,
              itemCount: _scheduleWeek.scheduleWeekList.length,
              itemBuilder: (ctx, index) {
                int day = index + 1;

                List<ScheduletimeOfDay> timesOfDay = [
                  ..._scheduleWeek.scheduleWeekList[index]
                ];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    children: [
                      Text(FormaterUtil.capitalize(_daysOfWeek[index])),
                      if (timesOfDay.isNotEmpty)
                        TextButton.icon(
                          label: Text(
                            _traslationMonth["duplicate"],
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          icon: const Icon(Icons.copy, size: 20),
                          onPressed: () => _duplicate(timesOfDay, day),
                          // tooltip: 'Copiar para próximo dia',
                        ),
                      SizedBox(
                        width: 120,
                        height: height - 91,
                        child: TimeOfDayBox(
                          addOne: (TimeOfDay timeOfDay) =>
                              _addOne(index, timeOfDay),
                          deleteOne: (DateTime timeOfDay) =>
                              _deleteOne(index, timeOfDay),
                          timesOfDay: timesOfDay,
                          date: DateTime.now(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Expanded(
            child: Divider(
              height: 0,
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, bottom: 10.0, top: 10.0),
            child: ElevatedButton(
              onPressed: _handleSave,
              child: Text(_traslation["save"]),
            ),
          ),
        ],
      ),
    );
  }
}

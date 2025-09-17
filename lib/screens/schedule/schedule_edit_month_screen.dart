import 'package:doctorfriend/components/callback.dart';
import 'package:doctorfriend/exeption/firestore_exception.dart';
import 'package:doctorfriend/exeption/handle_exception.dart';
import 'package:doctorfriend/models/schedule_month.dart';
import 'package:doctorfriend/models/schedule_time_of_day.dart';
import 'package:doctorfriend/screens/schedule/components/telemedicine.dart';
import 'package:doctorfriend/screens/schedule/components/time_of_day_box.dart';
import 'package:doctorfriend/services/schedule/schedule_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/utils/app_routes_util.dart';
import 'package:doctorfriend/utils/formater_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScheduleEditMonth extends StatefulWidget {
  final ScheduleMonth scheduleMonth;

  const ScheduleEditMonth({super.key, required this.scheduleMonth});

  @override
  State<ScheduleEditMonth> createState() => _ScheduleEditMonthState();
}

class _ScheduleEditMonthState extends State<ScheduleEditMonth> {
  late ScheduleMonth _scheduleMonth;
  bool _isSaved = false;
  bool _loading = false;
  bool _alerted = false;
  bool _isTelemedicine = false;
  late Map<String, dynamic> _traslation;
  late List<String> _daysOfWeek;
  late List<String> _montsOfYear;
  late ScrollController _scrollController;

  final _lang = Translations.currentLocale.languageCode;
  void _deleteOne(int day, DateTime timeOfDay) {
    try {
      _scheduleMonth.deleteOne(
        timeOfDay,
        _lang,
      );
      setState(() {});
    } on HandleException catch (error) {
      Callback.snackBar(context, title: error.message);
    } catch (error) {
      Callback.snackBar(context);
    }
  }

  void _addOne(int day, TimeOfDay timeOfDay) {
    try {
      _scheduleMonth.add(
        DateTime(
          _scheduleMonth.month.year,
          _scheduleMonth.month.month,
          day + 1,
          timeOfDay.hour,
          timeOfDay.minute,
        ),
        _isTelemedicine,
        _lang,
      );
      setState(() {});
    } on HandleException catch (error) {
      Callback.snackBar(context, title: error.message);
    } catch (error) {
      Callback.snackBar(context);
    }
  }

  Future<void> _getSavedPrefernces() async {
    final res = await _scheduleMonth.addStoredItems();
    if (res) {
      setState(() {});
    } else {
      if (_alerted) return;
      final openPrferences = await Callback.confirm(
        context: context,
        title: _traslation["preferences_title"],
        confirmText: _traslation["preferences_btn_confirm"],
        cancelText: _traslation["preferences_btn_cancel"],
        content: _traslation["preferences_btn_content"],
      );
      _alerted = true;

      if (openPrferences) {
        await context.push(AppRoutesUtil.scheduleEditDays);
        _getSavedPrefernces();
      }
    }
  }

  Future<void> _handleSave() async {
    setState(() => _loading = true);
    try {
      await ScheduleService().addScheduleMonth(scheduleMonth: _scheduleMonth);
      Callback.snackBar(context, error: false);
      Navigator.of(context).pop();
    } on FirestoreException catch (error) {
      Callback.snackBar(context, title: error.message);
    } catch (error) {
      Callback.snackBar(context);
    }
    setState(() => _loading = false);
  }

  bool _canDelete() {
    bool res = true;
    for (final value in _scheduleMonth.scheduleDays) {
      if (value.isSchedule) {
        res = false;
      }
    }
    return res;
  }

  Future<void> _delete() async {
    final res = await Callback.confirm(
      context: context,
      content: _traslation["delete_schedule"]
          .replaceAll(
            "{month}",
            FormaterUtil.capitalize(
                _montsOfYear[_scheduleMonth.month.month - 1]),
          )
          .replaceAll("{year}", _scheduleMonth.month.year.toString()),
    );

    if (!res) return;

    setState(() => _loading = true);
    try {
      await ScheduleService()
          .deleteMonth(scheduletimesOfDays: _scheduleMonth.scheduleDays);
      Navigator.of(context).pop();
    } on FirestoreException catch (error) {
      Callback.snackBar(context, title: error.message);
    } catch (error) {
      Callback.snackBar(context);
    }
    setState(() => _loading = false);
  }

  void _scrollToCurrentDay() {
    final now = DateTime.now();
    int currentDay = now.day;
    final int year = _scheduleMonth.month.year;
    final int month = _scheduleMonth.month.month;
    if (now.month != month || now.year != year) return;
    // Esperar até que o layout esteja completo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        (currentDay - 1) * 144.0, // Assumindo que cada item tem 100 de largura
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _scheduleMonth = widget.scheduleMonth;

    _isSaved = _scheduleMonth.scheduleDays.isNotEmpty;

    _scrollController = ScrollController();
    _scrollToCurrentDay();
    if (!_isSaved) _getSavedPrefernces();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final traslationContext = Translations.of(context);
    _traslation = traslationContext.translate('schedule_edit_month');
    _montsOfYear =
        traslationContext.translate('months_of_year')["list"].cast<String>();
    _daysOfWeek =
        traslationContext.translate('days_of_week')["list"].cast<String>();
  }

  @override
  Widget build(BuildContext context) {
    final int year = _scheduleMonth.month.year;
    final int month = _scheduleMonth.month.month;
    final height = MediaQuery.of(context).size.height - 325;
    return Scaffold(
      appBar: AppBar(
        title:
            Text("${FormaterUtil.capitalize(_montsOfYear[month - 1])} $year"),
        actions: [
          if (_isSaved && _canDelete())
            IconButton(
              onPressed: _delete,
              icon: const Icon(Icons.delete),
            ),
        ],
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
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 20.0),
              scrollDirection: Axis.horizontal,
              itemCount: _scheduleMonth.daysInMonth(),
              itemBuilder: (ctx, index) {
                int day = index + 1;
                int dayOfWeek = DateTime(year, month, day).weekday;
                List<ScheduletimeOfDay> scheduletimesOfDayFiltered = [
                  ..._scheduleMonth.scheduleDays
                ];
                scheduletimesOfDayFiltered.removeWhere((element) =>
                    element.timeOfDay.day != day ||
                    element.timeOfDay.month != month);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    children: [
                      Text(
                          "${FormaterUtil.capitalize(_daysOfWeek[dayOfWeek - 1].substring(0, 3))} - ${FormaterUtil.addZero(day)}"),
                      SizedBox(
                        width: 120,
                        height: height - 45,
                        child: TimeOfDayBox(
                          addOne: (TimeOfDay timeOfDay) =>
                              _addOne(index, timeOfDay),
                          deleteOne: (DateTime timeOfDay) =>
                              _deleteOne(index, timeOfDay),
                          timesOfDay: scheduletimesOfDayFiltered,
                          date: DateTime(year, month, day),
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
              onPressed: _loading ? null : _handleSave,
              child: Text(
                _isSaved ? _traslation["save"] : _traslation["save_schedule"],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

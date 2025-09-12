import 'package:doctorfriend/data/store.dart';
import 'package:doctorfriend/exeption/handle_exception.dart';
import 'package:doctorfriend/models/schedule_time_of_day.dart';
import 'package:doctorfriend/utils/formater_util.dart';

class ScheduleMonth {
  final String id;
  final String userId;
  final DateTime month;
  final List<ScheduletimeOfDay> scheduleDays;
  final DateTime updatedDate;
  final DateTime createdDate;

  ScheduleMonth({
    required this.id,
    required this.userId,
    required this.scheduleDays,
    required this.month,
    required this.updatedDate,
    required this.createdDate,
  }) {
    // for (int i = 0; i < daysInMonth(); i++) {
    //   scheduleDays.putIfAbsent(i.toString(), () => []);
    // }
  }

  final List<DateTime> deletedTimesOfDay = [];

  Future<bool> addStoredItems() async {
    Map<String, dynamic> stored =
        await Store.getMap("@schedulePreferencesForWeek");
    int count = 0;
    stored.forEach((weekday, value) {
      for (int i = 0; i < daysInMonth(); i++) {
        final int weekDayInMonth =
            DateTime(month.year, month.month, i + 1).weekday - 1;
        if (weekDayInMonth == int.parse(weekday)) {
          for (final val in value) {
            count++;
            scheduleDays.add(
              ScheduletimeOfDay(
                userId: userId,
                timeOfDay: DateTime(
                  month.year,
                  month.month,
                  i + 1,
                  val["hour"],
                  val["minute"],
                ),
                isTelemedicine: val["isTelemedicine"] ?? false,
                updatedByUser: null,
                customerId: null,
                customerName: null,
                updatedDate: null,
                createdDate: null,
              ),
            );
          }
        }
      }
    });
    return count > 0;
  }

  int daysInMonth() {
    DateTime ultimoDiaDoMes = DateTime(month.year, month.month + 1, 0);

    return ultimoDiaDoMes.day;
  }

  void deleteOne(DateTime time, String language) {
    scheduleDays.removeWhere((element) {
      final res = element.timeOfDay == time;
      if (res) {
        if (element.customerId != null) {
          throw HandleException(
            "already_scheduled",
            language,
          );
        }
        deletedTimesOfDay.add(time);
      }
      return res;
    });
  }

  void add(DateTime time, bool isTelemedicine, String language) {
    final dayList = scheduleDays;
    for (final val in dayList) {
      if (val.timeOfDay.toIso8601String() == time.toIso8601String()) {
        throw HandleException(
          "time_already_exists",
          language,
          "(${FormaterUtil.addZero(time.hour)}:${FormaterUtil.addZero(time.minute)})",
        );
      }
    }
    dayList.add(ScheduletimeOfDay(
      userId: userId,
      customerId: null,
      timeOfDay: time,
      isTelemedicine: isTelemedicine,
      customerName: null,
      updatedDate: null,
      createdDate: null,
      updatedByUser: null,
    ));
    dayList.sort((a, b) => _compareTime(
          a.timeOfDay,
          b.timeOfDay,
        ));
  }

  int _compareTime(DateTime a, DateTime b) {
    // Compara primeiro as horas e depois os minutos
    if (a.hour != b.hour) {
      return a.hour - b.hour;
    } else {
      return a.minute - b.minute;
    }
  }
}

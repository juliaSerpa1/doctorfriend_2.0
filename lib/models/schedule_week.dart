import 'package:doctorfriend/exeption/handle_exception.dart';
import 'package:doctorfriend/models/schedule_time_of_day.dart';

class ScheduleWeek {
  final List<ScheduletimeOfDay> monday = [];
  final List<ScheduletimeOfDay> tuesday = [];
  final List<ScheduletimeOfDay> wednesday = [];
  final List<ScheduletimeOfDay> thursday = [];
  final List<ScheduletimeOfDay> friday = [];
  final List<ScheduletimeOfDay> saturday = [];
  final List<ScheduletimeOfDay> sunday = [];

  ScheduleWeek();

  void deleteOne(int day, DateTime time) {
    if (day == 0) {
      monday.removeWhere((element) => element.timeOfDay == time);
    } else if (day == 1) {
      tuesday.removeWhere((element) => element.timeOfDay == time);
    } else if (day == 2) {
      wednesday.removeWhere((element) => element.timeOfDay == time);
    } else if (day == 3) {
      thursday.removeWhere((element) => element.timeOfDay == time);
    } else if (day == 4) {
      friday.removeWhere((element) => element.timeOfDay == time);
    } else if (day == 5) {
      saturday.removeWhere((element) => element.timeOfDay == time);
    } else if (day == 6) {
      sunday.removeWhere((element) => element.timeOfDay == time);
    }
  }

  void add({
    required int day,
    required DateTime time,
    required bool isTelemedicine,
    required String userId,
    required String language,
  }) {
    String errText = "time_already_exists";

    if (day == 0) {
      for (final val in monday) {
        if (val.timeOfDay.hour == time.hour &&
            val.timeOfDay.minute == time.minute) {
          throw HandleException(errText, language);
        }
      }
      monday.add(ScheduletimeOfDay(
        userId: userId,
        customerId: null,
        customerName: null,
        updatedDate: null,
        createdDate: null,
        updatedByUser: null,
        timeOfDay: time,
        isTelemedicine: isTelemedicine,
      ));
      monday.sort((a, b) => _compareTime(a.timeOfDay, b.timeOfDay));
    } else if (day == 1) {
      for (final val in tuesday) {
        if (val.timeOfDay.hour == time.hour &&
            val.timeOfDay.minute == time.minute) {
          throw HandleException(errText, language);
        }
      }
      tuesday.add(ScheduletimeOfDay(
        userId: userId,
        customerId: null,
        customerName: null,
        updatedDate: null,
        createdDate: null,
        updatedByUser: null,
        timeOfDay: time,
        isTelemedicine: isTelemedicine,
      ));
      tuesday.sort((a, b) => _compareTime(a.timeOfDay, b.timeOfDay));
    } else if (day == 2) {
      for (final val in wednesday) {
        if (val.timeOfDay.hour == time.hour &&
            val.timeOfDay.minute == time.minute) {
          throw HandleException(errText, language);
        }
      }
      wednesday.add(ScheduletimeOfDay(
        userId: userId,
        customerId: null,
        customerName: null,
        updatedDate: null,
        updatedByUser: null,
        createdDate: null,
        timeOfDay: time,
        isTelemedicine: isTelemedicine,
      ));
      wednesday.sort((a, b) => _compareTime(a.timeOfDay, b.timeOfDay));
    } else if (day == 3) {
      for (final val in thursday) {
        if (val.timeOfDay.hour == time.hour &&
            val.timeOfDay.minute == time.minute) {
          throw HandleException(errText, language);
        }
      }
      thursday.add(ScheduletimeOfDay(
        userId: userId,
        customerId: null,
        customerName: null,
        updatedDate: null,
        updatedByUser: null,
        createdDate: null,
        timeOfDay: time,
        isTelemedicine: isTelemedicine,
      ));
      thursday.sort((a, b) => _compareTime(a.timeOfDay, b.timeOfDay));
    } else if (day == 4) {
      for (final val in friday) {
        if (val.timeOfDay.hour == time.hour &&
            val.timeOfDay.minute == time.minute) {
          throw HandleException(errText, language);
        }
      }
      friday.add(ScheduletimeOfDay(
        userId: userId,
        customerId: null,
        customerName: null,
        updatedDate: null,
        updatedByUser: null,
        createdDate: null,
        timeOfDay: time,
        isTelemedicine: isTelemedicine,
      ));
      friday.sort((a, b) => _compareTime(a.timeOfDay, b.timeOfDay));
    } else if (day == 5) {
      for (final val in saturday) {
        if (val.timeOfDay.hour == time.hour &&
            val.timeOfDay.minute == time.minute) {
          throw HandleException(errText, language);
        }
      }
      saturday.add(ScheduletimeOfDay(
        userId: userId,
        customerId: null,
        customerName: null,
        updatedDate: null,
        updatedByUser: null,
        createdDate: null,
        timeOfDay: time,
        isTelemedicine: isTelemedicine,
      ));
      saturday.sort((a, b) => _compareTime(a.timeOfDay, b.timeOfDay));
    } else if (day == 6) {
      for (final val in sunday) {
        if (val.timeOfDay.hour == time.hour &&
            val.timeOfDay.minute == time.minute) {
          throw HandleException(errText, language);
        }
      }
      sunday.add(ScheduletimeOfDay(
        userId: userId,
        customerId: null,
        customerName: null,
        updatedDate: null,
        updatedByUser: null,
        createdDate: null,
        timeOfDay: time,
        isTelemedicine: isTelemedicine,
      ));
      sunday.sort((a, b) => _compareTime(a.timeOfDay, b.timeOfDay));
    }
  }

  List<List<ScheduletimeOfDay>> get scheduleWeekList {
    return [monday, tuesday, wednesday, thursday, friday, saturday, sunday];
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

// _handleSelectTime(TimeOfDay time) {
//   setState(() {
//     _selectedTime = time;
//     _controllerTime.text =
//         "${_selectedTime.hour}:${_selectedTime.minute < 10 ? '0' : ''}${_selectedTime.minute}";
//   });
// }

// TimeOfDay? newTime = await showTimePicker(
//   context: context,
//   initialTime: _selectedTime,
// );
// if (newTime != null) {
//   _handleSelectTime(newTime);
// }

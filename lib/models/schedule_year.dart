import 'package:doctorfriend/models/schedule_time_of_day.dart';

class ScheduleYear {
  final int year;
  final Map<int, List<ScheduletimeOfDay>> scheduleMonthsInYear;

  const ScheduleYear({
    required this.year,
    required this.scheduleMonthsInYear,
  });
}

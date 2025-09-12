import 'package:doctorfriend/models/schedule_month.dart';
import 'package:doctorfriend/models/schedule_time_of_day.dart';
import 'package:doctorfriend/models/schedule_year.dart';
import 'package:doctorfriend/services/schedule/schedule_firebase_service.dart';

abstract class ScheduleService {
  Stream<ScheduleYear> scheduleYear({
    required String userId,
    required int year,
  });
  Stream<List<ScheduletimeOfDay>?> scheduleMonth({
    required String userId,
    required DateTime month,
  });

  Future<void> addScheduleMonth({
    required ScheduleMonth scheduleMonth,
  });

  Future<void> addScheduleDay({
    required ScheduletimeOfDay scheduletimeOfDay,
  });

  Future<ScheduletimeOfDay?> getScheduleDayHistory({
    required String referenceId,
  });

  Future<void> updateScheduleMonth({
    required ScheduleMonth scheduleMonth,
  });

  Future<void> deleteMonth({
    required List<ScheduletimeOfDay> scheduletimesOfDays,
  });

  Future<void> markAsNotified({
    required String userId,
    required String scheduleId,
    required String? notificationId,
  });

  factory ScheduleService() {
    return ScheduleFirebaseService();
  }
}

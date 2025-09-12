// import 'package:doctorfriend/models/schedule_month.dart';
// import 'package:doctorfriend/models/schedule_time_of_day.dart';
// import 'package:doctorfriend/models/schedule_year.dart';
// import 'package:doctorfriend/services/schedule/schedule_firebase_service.dart';

// abstract class ScheduleService {
//   Stream<ScheduleYear> scheduleYear({
//     required String userId,
//     required int year,
//   });
//   Stream<ScheduleMonth?> scheduleMonth({
//     required String userId,
//     required DateTime month,
//   });

//   Future<void> addScheduleMonth({
//     required ScheduleMonth scheduleMonth,
//   });

//   Future<void> addScheduleDay({
//     required String userId,
//     required ScheduletimeOfDay scheduletimeOfDay,
//   });

//   Future<void> updateScheduleMonth({
//     required String userId,
//     required ScheduleMonth scheduleMonth,
//   });

//   Future<void> deleteMonth({
//     required String monthId,
//   });

//   Future<void> markAsNotified({
//     required String userId,
//     required DateTime timeOfDay,
//     required String? notificationId,
//   });

//   factory ScheduleService() {
//     return ScheduleFirebaseService();
//   }
// }

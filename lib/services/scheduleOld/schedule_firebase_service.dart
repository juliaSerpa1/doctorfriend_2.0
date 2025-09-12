// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:doctorfriend/exeption/firestore_exception.dart';
// import 'package:doctorfriend/models/schedule_month.dart';
// import 'package:doctorfriend/models/schedule_time_of_day.dart';
// import 'package:doctorfriend/models/schedule_year.dart';
// import 'package:doctorfriend/services/schedule/schedule_service.dart';
// import 'package:doctorfriend/services/traslation/traslation.dart';
// import 'package:doctorfriend/utils/firebase/firebase_firestore_util.dart';
// import 'package:doctorfriend/utils/firebase/firebase_tables_util.dart';

// class ScheduleFirebaseService implements ScheduleService {
//   final String table = FirebaseTablesUtil.schedule;
//   final store = FirebaseFirestoreUtil.store;
//   final String _lang = Translations.currentLocale.languageCode;
//   @override
//   Stream<ScheduleYear> scheduleYear({
//     required String userId,
//     required int year,
//   }) {
//     final DateTime dateStart = DateTime(year);
//     final DateTime dateEnd =
//         DateTime(year + 1).subtract(const Duration(days: 1));

//     final snapshots = store
//         .collection(table)
//         .withConverter(
//           fromFirestore: _fromFirestore,
//           toFirestore: _toFirestore,
//         )
//         .where(
//           "month",
//           isGreaterThanOrEqualTo: Timestamp.fromDate(dateStart),
//           isLessThanOrEqualTo: Timestamp.fromDate(dateEnd),
//         )
//         .where("userId", isEqualTo: userId)
//         .orderBy('month')
//         .snapshots();

//     return snapshots.map((snapshot) {
//       final Map<int, ScheduleMonth> scheduleMonthsInYear = {};

//       for (final doc in snapshot.docs) {
//         final data = doc.data();
//         scheduleMonthsInYear.putIfAbsent(data.month.month, () => data);
//       }

//       return ScheduleYear(
//         year: year,
//         scheduleMonthsInYear: scheduleMonthsInYear,
//       );
//     });
//   }

//   @override
//   Stream<ScheduleMonth?> scheduleMonth({
//     required String userId,
//     required DateTime month,
//   }) {
//     final snapshots = store
//         .collection(table)
//         .doc("$userId-${month.month}-${month.year}")
//         .withConverter(
//           fromFirestore: _fromFirestore,
//           toFirestore: _toFirestore,
//         )
//         .snapshots();

//     return snapshots.map((snapshot) {
//       return snapshot.data();
//     });
//   }

//   @override
//   Future<void> addScheduleMonth({
//     required ScheduleMonth scheduleMonth,
//   }) async {
//     try {
//       final uid =
//           "${scheduleMonth.userId}-${scheduleMonth.month.month}-${scheduleMonth.month.year}";
//       final docRef = store.collection(table).doc(uid);

//       return await docRef.set(_toFirestore(scheduleMonth, null, true));
//     } on FirebaseException catch (e) {
//       throw FirestoreException(e.code, _lang);
//     }
//   }

//   @override
//   Future<void> addScheduleDay({
//     required String userId,
//     required ScheduletimeOfDay scheduletimeOfDay,
//   }) async {
//     try {
//       final date = scheduletimeOfDay.timeOfDay.toUtc();
//       final String day = (date.day - 1).toString();
//       final String time = "${date.hour}:${date.minute}";
//       await FirebaseFirestoreUtil.update(
//         table: table,
//         id: "$userId-${date.month}-${date.year}",
//         data: {
//           'scheduleDays.$day.$time': scheduletimeOfDay.toMap,
//         },
//       );
//     } on FirebaseException catch (e) {
//       throw FirestoreException(e.code, _lang);
//     }
//   }

//   @override
//   Future<void> markAsNotified({
//     required String userId,
//     required DateTime timeOfDay,
//     required String? notificationId,
//   }) async {
//     try {
//       final date = timeOfDay.toUtc();
//       final String day = (date.day - 1).toString();
//       final String time = "${date.hour}:${date.minute}";
//       await FirebaseFirestoreUtil.update(
//         table: table,
//         id: "$userId-${date.month}-${date.year}",
//         data: {
//           'scheduleDays.$day.$time.notificationId': notificationId,
//         },
//       );
//     } on FirebaseException catch (e) {
//       throw FirestoreException(e.code, _lang);
//     }
//   }

//   @override
//   Future<void> updateScheduleMonth({
//     required String userId,
//     required ScheduleMonth scheduleMonth,
//   }) async {}

//   @override
//   Future<void> deleteMonth({
//     required String monthId,
//   }) async {
//     try {
//       await FirebaseFirestoreUtil.delete(
//         table: table,
//         id: monthId,
//       );
//     } on FirebaseException catch (e) {
//       throw FirestoreException(e.code, _lang);
//     }
//   }

//   Map<String, dynamic> _toFirestore(
//     ScheduleMonth scheduleMonth,
//     SetOptions? options, [
//     register = false,
//   ]) {
//     final Map<String, Map<String, dynamic>> scheduleDaysMap = {};
//     scheduleMonth.scheduleDays.forEach((key, value) {
//       scheduleDaysMap.putIfAbsent(
//         key,
//         () {
//           final Map<String, dynamic> scheduleDayMap = {};
//           for (final val in value) {
//             //ADICIONA EM UTC PARA PESQUISA DE HORARIO
//             final timeOfDay = val.timeOfDay.toUtc();
//             //CRIA A AGENDA DE HORARIO EM UTC
//             scheduleDayMap.putIfAbsent(
//               "${timeOfDay.hour}:${timeOfDay.minute}",
//               () => val.toMap,
//             );
//           }
//           return scheduleDayMap;
//         },
//       );
//     });
//     final map = {
//       'month': Timestamp.fromDate(
//         DateTime(
//           scheduleMonth.month.year,
//           scheduleMonth.month.month,
//         ),
//       ),
//       'userId': scheduleMonth.userId,
//       'scheduleDays': scheduleDaysMap,
//       'updatedDate': Timestamp.now(),
//       'createdDate': Timestamp.now(),
//     };

//     if (register) {
//       map.putIfAbsent("createdDate", () => Timestamp.now());
//     }

//     return map;
//   }

//   static ScheduleMonth _fromFirestore(
//     DocumentSnapshot<Map<String, dynamic>> doc,
//     SnapshotOptions? options,
//   ) {
//     Map<String, dynamic> data = doc.data()!;

//     Map<String, List<ScheduletimeOfDay>> scheduleDays = {};

//     data['scheduleDays'].forEach((key, value) {
//       scheduleDays.putIfAbsent(key, () {
//         final List<ScheduletimeOfDay> list = [];
//         value.forEach((key, value) {
//           list.add(ScheduletimeOfDay(
//             timeOfDay: value['timeOfDay']?.toDate(),
//             customerId: value['customerId'],
//             customerName: value['customerName'],
//             customerEmail: value['customerEmail'],
//             customerService: value['customerService'],
//             customerPhone: value['customerPhone'],
//             customerNote: value['customerNote'],
//             confirmed: value['confirmed'],
//             finished: value['finished'],
//             notificationId: value['notificationId'],
//             updatedByUser: value['updatedByUser'],
//             isTelemedicine: value['isTelemedicine'] ?? false,
//             updatedDate: value['updatedDate']?.toDate(),
//             createdDate: value['createdDate']?.toDate(),
//           ));
//         });

//         list.sort((a, b) => _compareTime(
//               a.timeOfDay,
//               b.timeOfDay,
//             ));

//         return list;
//       });
//     });

//     return ScheduleMonth(
//       id: doc.id,
//       userId: data['userId'],
//       month: data['month'].toDate(),
//       scheduleDays: scheduleDays,
//       updatedDate: data['updatedDate']?.toDate(),
//       createdDate: data['createdDate']?.toDate(),
//     );
//   }

//   static int _compareTime(DateTime a, DateTime b) {
//     // Compara primeiro as horas e depois os minutos
//     if (a.hour != b.hour) {
//       return a.hour - b.hour;
//     } else {
//       return a.minute - b.minute;
//     }
//   }
// }

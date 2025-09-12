import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorfriend/exeption/firestore_exception.dart';
import 'package:doctorfriend/models/schedule_month.dart';
import 'package:doctorfriend/models/schedule_time_of_day.dart';
import 'package:doctorfriend/models/schedule_year.dart';
import 'package:doctorfriend/services/schedule/schedule_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/utils/firebase/firebase_firestore_util.dart';
import 'package:doctorfriend/utils/firebase/firebase_tables_util.dart';

class ScheduleFirebaseService implements ScheduleService {
  final String table = FirebaseTablesUtil.schedules;
  final String subTable = FirebaseTablesUtil.schedule;
  final store = FirebaseFirestoreUtil.store;
  final String _lang = Translations.currentLocale.languageCode;
  @override
  Stream<ScheduleYear> scheduleYear({
    required String userId,
    required int year,
  }) {
    final DateTime dateStart = DateTime(year).subtract(const Duration(days: 1));

    final DateTime dateEnd = DateTime(year + 1);

    final snapshots = store
        .collection(table)
        .doc(userId)
        .collection(subTable)
        .withConverter(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        )
        .where(
          "timeOfDay",
          isGreaterThanOrEqualTo: Timestamp.fromDate(dateStart),
          isLessThanOrEqualTo: Timestamp.fromDate(dateEnd),
        )
        .orderBy('timeOfDay')
        .snapshots();

    return snapshots.map((snapshot) {
      final Map<int, List<ScheduletimeOfDay>> scheduleMonthsInYear = {};

      for (final doc in snapshot.docs) {
        final data = doc.data();
        scheduleMonthsInYear.putIfAbsent(data.timeOfDay.month, () => []);
        scheduleMonthsInYear[data.timeOfDay.month]?.add(data);
      }

      return ScheduleYear(
        year: year,
        scheduleMonthsInYear: scheduleMonthsInYear,
      );
    });
  }

  @override
  Stream<List<ScheduletimeOfDay>?> scheduleMonth({
    required String userId,
    required DateTime month,
  }) {
    DateTime oneMonthBefore = DateTime(month.year, month.month, 1);
    DateTime oneMonthAfter = DateTime(month.year, month.month + 1, 1);

    final snapshots = store
        .collection(table)
        .doc(userId)
        .collection(subTable)
        .where(
          "timeOfDay",
          isGreaterThanOrEqualTo: Timestamp.fromDate(oneMonthBefore),
          isLessThanOrEqualTo: Timestamp.fromDate(oneMonthAfter),
        )
        .where("userId", isEqualTo: userId)
        .withConverter<ScheduletimeOfDay>(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        )
        .snapshots();

    return snapshots.map((snapshot) {
      final data = snapshot.docs.map((doc) => doc.data()).toList();
      return data;
    });
  }

  @override
  Future<void> addScheduleMonth({
    required ScheduleMonth scheduleMonth,
  }) async {
    try {
      // Inicia uma operação em lote
      final batch = store.batch();

      // Adiciona cada dia do mês ao lote
      for (final scheduleDay in scheduleMonth.scheduleDays) {
        final docRef = store
            .collection(table)
            .doc(scheduleDay.userId)
            .collection(subTable)
            .doc(scheduleDay.id);
        batch.set(docRef, scheduleDay.toMap);
      }

      //deltar as datas que foram marcadas para deletar
      await _deleteDatesOfTime(
        userId: scheduleMonth.userId,
        datesOfTime: scheduleMonth.deletedTimesOfDay,
      );
      //salvar a agenda completa
      await batch.commit();
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, _lang);
    }
  }

  @override
  Future<void> addScheduleDay({
    required ScheduletimeOfDay scheduletimeOfDay,
  }) async {
    try {
      final docRef = store
          .collection(table)
          .doc(scheduletimeOfDay.userId)
          .collection(subTable)
          .doc(scheduletimeOfDay.id);
      docRef.update(scheduletimeOfDay.toMap);
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, _lang);
    }
  }

  @override
  Future<ScheduletimeOfDay?> getScheduleDayHistory({
    required String referenceId,
  }) async {
    final snapshots = await store
        .collection("scheduleHistory")
        .doc(referenceId)
        .withConverter<ScheduletimeOfDay>(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        )
        .get();

    if (snapshots.exists) {
      return snapshots.data();
    }
    return null;
  }

  @override
  Future<void> markAsNotified({
    required String userId,
    required String scheduleId,
    required String? notificationId,
  }) async {
    try {
      final docRef = store
          .collection(table)
          .doc(userId)
          .collection(subTable)
          .doc(scheduleId);
      docRef.update({
        'notificationId': notificationId,
      });
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, _lang);
    }
  }

  @override
  Future<void> updateScheduleMonth({
    required ScheduleMonth scheduleMonth,
  }) async {}

  @override
  Future<void> deleteMonth({
    required List<ScheduletimeOfDay> scheduletimesOfDays,
  }) async {
    try {
      final batch = store.batch();

      // Adiciona cada dia do mês ao lote
      for (final scheduleTimeOfDay in scheduletimesOfDays) {
        final docRef = store
            .collection(table)
            .doc(scheduleTimeOfDay.userId)
            .collection(subTable)
            .doc(scheduleTimeOfDay.id);
        batch.delete(docRef);
      }
      // Executa o lote de operações
      await batch.commit();
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, _lang);
    }
  }

  Future<void> _deleteDatesOfTime({
    required String userId,
    required List<DateTime> datesOfTime,
  }) async {
    try {
      final batch = store.batch();

      // Adiciona cada dia do mês ao lote
      for (final dateOfTime in datesOfTime) {
        final docRef = store
            .collection(table)
            .doc(userId)
            .collection(subTable)
            .doc(dateOfTime.toUtc().toIso8601String());
        batch.delete(docRef);
      }
      // Executa o lote de operações
      await batch.commit();
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, _lang);
    }
  }

  Map<String, dynamic> _toFirestore(
    ScheduletimeOfDay scheduletimeOfDay,
    SetOptions? options, [
    register = false,
  ]) {
    return scheduletimeOfDay.toMap;
  }

  static ScheduletimeOfDay _fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    Map<String, dynamic> data = doc.data()!;

    return ScheduletimeOfDay(
      userId: data['userId'],
      timeOfDay: data['timeOfDay']?.toDate(),
      customerId: data['customerId'],
      customerName: data['customerName'],
      customerEmail: data['customerEmail'],
      customerService: data['customerService'],
      customerPhone: data['customerPhone'],
      customerNote: data['customerNote'],
      confirmed: data['confirmed'],
      finished: data['finished'],
      notificationId: data['notificationId'],
      updatedByUser: data['updatedByUser'],
      type: data['type'],
      isTelemedicine: data['isTelemedicine'] ?? false,
      updatedDate: data['updatedDate']?.toDate(),
      createdDate: data['createdDate']?.toDate(),
    );
  }

  // static int _compareTime(DateTime a, DateTime b) {
  //   // Compara primeiro as horas e depois os minutos
  //   if (a.hour != b.hour) {
  //     return a.hour - b.hour;
  //   } else {
  //     return a.minute - b.minute;
  //   }
  // }
}

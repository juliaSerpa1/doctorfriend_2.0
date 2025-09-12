import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorfriend/data/constants.dart';
import 'package:doctorfriend/exeption/firestore_exception.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/models/schedule_time_of_day.dart';
import 'package:doctorfriend/services/email/email_service.dart';
import 'package:doctorfriend/services/schedule/schedule_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/utils/firebase/firebase_firestore_util.dart';
import 'package:doctorfriend/utils/firebase/firebase_tables_util.dart';
import 'package:doctorfriend/utils/formater_util.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class EmailFirebaseService implements EmailService {
  final String table = FirebaseTablesUtil.email;
  final store = FirebaseFirestoreUtil.store;
  final String _lang = Translations.currentLocale.languageCode;

  @override
  Future<Stream<Map<String, dynamic>?>> sendRemaiderEmail({
    required ScheduletimeOfDay scheduletimeOfDay,
    required AppUser user,
    required Translations traslationContext,
  }) async {
    try {
      // final fcmToken = await FirebaseMessaging.instance.getToken();
      final docRef = store.collection(table);
      final email = await _remaiderEmail(
        scheduletimeOfDay: scheduletimeOfDay,
        user: user,
        traslationContext: traslationContext,
      );
      // throw FirestoreException("e.code");
      final newElementRef = await docRef.add({
        "to": [scheduletimeOfDay.customerEmail],
        "message": {
          "subject": traslationContext
              .translate("schedule_reminder")["title"]
              .replaceAll("{date}",
                  FormaterUtil.formatDate(scheduletimeOfDay.timeOfDay, true)),
          "html": email,
        }
      });
      // Obtenha o ID do novo elemento
      final id = newElementRef.id;

      await ScheduleService().markAsNotified(
        userId: user.id,
        scheduleId: scheduletimeOfDay.id,
        notificationId: id,
      );

      final snapshots = store.collection(table).doc(id).snapshots();

      return snapshots.map((snapshot) {
        final data = snapshot.data();
        final String state = data?["delivery"]?["state"] ?? "PENDING";
        final String? error = data?["delivery"]?["error"];
        if (error != null) {
          ScheduleService().markAsNotified(
            userId: user.id,
            scheduleId: scheduletimeOfDay.id,
            notificationId: null,
          );
        }
        return {
          "state": state,
          "stateCode": state == "FAILED" || error != null
              ? 3
              : state == "SUCCESS"
                  ? 0
                  : state == "PROCESSING"
                      ? 1
                      : 2,
          "error": error,
        };
      });
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, _lang);
    }
  }
}

Future<String> _remaiderEmail({
  required ScheduletimeOfDay scheduletimeOfDay,
  required AppUser user,
  required Translations traslationContext,
}) async {
  String res = "";
  final String customerId = scheduletimeOfDay.customerId ?? "";
  final montsOfYear =
      traslationContext.translate('months_of_year')["list"].cast<String>();
  final daysOfWeek =
      traslationContext.translate('days_of_week')["list"].cast<String>();
  final today = traslationContext.translate('today')["text"];
  final dateString = FormaterUtil.formatDateTextFull(
    date: scheduletimeOfDay.timeOfDay,
    daysOfWeek: daysOfWeek,
    montsOfYear: montsOfYear,
    today: today,
  );
  final locale = traslationContext.locale;
  final localeName =
      "${locale.languageCode}-${locale.countryCode}".toLowerCase();
  final url = Uri.parse(
      "$kApiUrl/remaiderEmail?dateString=$dateString&customerName=${scheduletimeOfDay.customerName}&addressString=${user.addresses[0].addressString}&userEmail=${user.email}&userPhone=${user.phone}&isTelemedicine=${scheduletimeOfDay.isTelemedicine}&customerId=$customerId&localeName=$localeName");
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data["email"] != null) {
      res = data["email"];
    }
  } else {
    if (response.statusCode == 500) {
      final data = json.decode(response.body);
      final error = data["error"];
      throw Exception(error ?? "${response.statusCode}");
    }
    throw Exception("${response.statusCode}");
  }
  return res;
}

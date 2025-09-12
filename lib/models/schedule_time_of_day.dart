import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorfriend/utils/formater_util.dart';

class ScheduletimeOfDay {
  final String userId;
  final DateTime timeOfDay;
  final String? customerId;

  final String? customerName;
  final String? customerPhone;
  final String? customerEmail;
  final String? customerService;
  final String? customerNote;
  final bool confirmed;
  final bool isTelemedicine;
  final String? notificationId;
  final bool finished;
  final String? updatedByUser;
  final String? type;
  final DateTime? updatedDate;
  final DateTime? createdDate;

  const ScheduletimeOfDay({
    required this.userId,
    required this.timeOfDay,
    required this.customerId,
    required this.customerName,
    required this.isTelemedicine,
    this.customerPhone,
    this.customerEmail,
    this.customerService,
    this.customerNote,
    this.confirmed = false,
    this.finished = false,
    required this.updatedByUser,
    this.type,
    required this.updatedDate,
    required this.createdDate,
    this.notificationId,
  });

  Map<String, dynamic> get toMap {
    return {
      "userId": userId,
      "timeOfDay": Timestamp.fromDate(timeOfDay),
      "customerId": customerId,
      "customerName": customerName,
      "customerPhone": customerPhone,
      "customerEmail": customerEmail,
      "customerService": customerService,
      "customerNote": customerNote,
      "confirmed": confirmed,
      "notificationId": notificationId,
      "isTelemedicine": isTelemedicine,
      "finished": finished,
      "updatedByUser": updatedByUser,
      "updatedDate": updatedDate != null ? Timestamp.now() : null,
      "createdDate": createdDate != null
          ? Timestamp.fromDate(createdDate!)
          : Timestamp.now(),
    };
  }

  String get timeOfDayString {
    return "${FormaterUtil.addZero(timeOfDay.hour)}:${FormaterUtil.addZero(timeOfDay.minute)}";
  }

  bool get isSchedule {
    return customerName != null;
  }

  bool get isCanceled {
    return type == "unschedule";
  }

  bool get isAfter {
    return timeOfDay.isAfter(DateTime.now());
  }

  String get id {
    final timeUTC = timeOfDay.toUtc();
    // final timeKey = _toScheduleDayFormat(timeUTC);
    return timeUTC.toIso8601String();
  }

  // String _toScheduleDayFormat(DateTime date) {
  //   //data em utc
  //   return date.toIso8601String().replaceAll('.', '_');
  // }
}

enum NotificationsType {
  none,
  schedule,
  unschedule,
  freeTrialExpiration,
  evaluation,
}

class NotificationApp {
  final String id;
  final NotificationsType type;
  final String title;
  final String message;
  final String userId;
  final String? customerId;
  final DateTime notificationDate;
  final DateTime? timeOfDay;
  final String? referenceId;

  final Map<String, dynamic>? data;

  const NotificationApp({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.userId,
    required this.customerId,
    required this.notificationDate,
    required this.timeOfDay,
    required this.data,
    required this.referenceId,
  });
}

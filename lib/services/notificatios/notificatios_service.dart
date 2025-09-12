import 'package:doctorfriend/models/notification_app.dart';
import 'package:doctorfriend/services/notificatios/notificatios_firebase_service.dart';

abstract class NotificationsService {
  Stream<List<NotificationApp>> notifications();

  Future<NotificationApp?> getNotification({
    required String id,
  });

  Stream<List<String>?> get notificationsStoredChanges;

  List<String> get notificationsStored;

  Future<void> notificationsOpen();

  Future<void> markAsOpen(List<NotificationApp> notification);

  factory NotificationsService() {
    return NotificatiosFirebaseService();
  }
}

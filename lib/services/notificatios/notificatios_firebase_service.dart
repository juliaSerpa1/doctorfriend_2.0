import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorfriend/data/store.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/models/notification_app.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:doctorfriend/services/notificatios/notificatios_service.dart';
import 'package:doctorfriend/utils/firebase/firebase_firestore_util.dart';
import 'package:doctorfriend/utils/firebase/firebase_tables_util.dart';

final String table = FirebaseTablesUtil.notifications;
final store = FirebaseFirestoreUtil.store;

class NotificatiosFirebaseService implements NotificationsService {
  NotificatiosFirebaseService() {
    notificationsOpen();
  }

  @override
  Future<NotificationApp?> getNotification({required String id}) async {
    if (id.trim() == "") return null;
    final snapshots = store.collection(table).doc(id).withConverter(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        );

    final doc = await snapshots.get();

    return doc.data();
  }

  @override
  Stream<List<NotificationApp>> notifications() {
    final AppUser user = AuthService().currentUser!;
    final snapshots = store
        .collection(table)
        .withConverter(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        )
        .where("userId", isEqualTo: user.id)
        .orderBy('notificationDate', descending: true)
        .limit(100)
        .snapshots();

    return snapshots.map((snapshot) {
      return snapshot.docs.map((doc) {
        return doc.data();
      }).toList();
    });
  }

  static List<String>? _notificationsStored;

  static MultiStreamController<List<String>?>? _controller;

  static final _notificationsStoredStream =
      Stream<List<String>?>.multi((controller) async {
    _controller = controller;
  });

  @override
  Stream<List<String>?> get notificationsStoredChanges {
    return _notificationsStoredStream;
  }

  @override
  List<String> get notificationsStored {
    return _notificationsStored ?? [];
  }

  @override
  Future<void> notificationsOpen() async {
    List<dynamic> store = await Store.getList("@notificationsOpen");
    final stored = store.cast<String>();
    _controller?.add(stored);
  }

  @override
  Future<void> markAsOpen(List<NotificationApp> notification) async {
    List<String> list = notification.map((e) => e.id).toList();
    await Store.saveList("@notificationsOpen", list);
    notificationsOpen();
  }

  Map<String, dynamic> _toFirestore(
    NotificationApp notificationApp,
    SetOptions? options, [
    register = false,
  ]) {
    final map = {
      'type': notificationApp.type.name,
      'title': notificationApp.title,
      'message': notificationApp.message,
      'userId': notificationApp.userId,
      'notificationDate': Timestamp.fromDate(notificationApp.notificationDate),
      'data': notificationApp.data,
    };

    return map;
  }

  static NotificationApp _fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    Map<String, dynamic> data = doc.data()!;
    NotificationsType type = NotificationsType.none;
    try {
      type = NotificationsType.values.firstWhere((e) => e.name == data['type']);
    } catch (e) {}
    return NotificationApp(
      id: doc.id,
      type: type,
      userId: data['userId'].toString(),
      customerId: data['customerId'],
      message: data['message'].toString(),
      title: data['title'].toString(),
      notificationDate: data['notificationDate'].toDate(),
      timeOfDay: data['timeOfDay']?.toDate(),
      data: data['data'],
      referenceId: data['referenceId'],
    );
  }
}

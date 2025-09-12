import 'package:doctorfriend/components/loading_indicator.dart';
import 'package:doctorfriend/components/modal_notifications.dart';
import 'package:doctorfriend/models/notification_app.dart';
import 'package:doctorfriend/services/notificatios/notificatios_service.dart';
import 'package:flutter/material.dart';

class NotificationButton extends StatefulWidget {
  const NotificationButton({super.key});

  @override
  State<NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> {
  List<String> _stored = [];
  // _notificationsOpen() async {
  //   List<dynamic> store = await Store.getList("@notificationsOpen");
  //   setState(() {
  //     _stored = store.cast<String>();
  //   });
  // }

  // _markAsOpen(List<NotificationApp> notification) async {
  //   List<String> list = notification.map((e) => e.id).toList();
  //   await Store.saveList("@notificationsOpen", list);
  //   _notificationsOpen();
  // }

  // Future<bool> get _isAuthorized async {
  //   final messaging = FirebaseMessaging.instance;
  //   final settings = await messaging.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true,
  //   );
  //   return settings.authorizationStatus == AuthorizationStatus.authorized;
  // }

  // Future<void> _setupInteractedMessage() async {
  //   if (!await _isAuthorized) return;

  //   FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  // }

  // void _handleMessage(RemoteMessage remoteMessage) {
  //   if (remoteMessage.data['type'] == 'schedule') {
  //     _autoOpen = true;
  //   } else if (remoteMessage.data['type'] == 'unschedule') {
  //     _autoOpen = true;
  //   }
  // }

  @override
  void initState() {
    super.initState();
    NotificationsService().notificationsStoredChanges.listen((event) {
      final data = event ?? [];
      if (data.length != _stored.length) {
        _stored = data;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<NotificationApp>>(
      stream: NotificationsService().notifications(),
      builder: (context, snapshot) {
        final List<NotificationApp> notifications = snapshot.data ?? [];
        bool loading = snapshot.connectionState == ConnectionState.waiting;

        final error = snapshot.error;

        final notificationsView = [...notifications];

        for (final val in _stored) {
          notificationsView.removeWhere((element) => element.id == val);
        }

        final int length = notificationsView.length;

        final String amount = length > 99 ? "+99" : length.toString();

        return LoadingIndicator(
          loading: loading,
          error: error != null,
          errorMessage: "Error",
          child: Stack(
            alignment: AlignmentDirectional.center,
            fit: StackFit.expand,
            children: [
              if (length > 0)
                Positioned(
                  right: 5,
                  top: 5,
                  child: Text(
                    amount,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                ),
              FittedBox(
                child: IconButton(
                  icon: Icon(
                    length > 0
                        ? Icons.notifications_active_outlined
                        : Icons.notifications_none,
                  ),
                  onPressed: () {
                    ModalNotifications(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

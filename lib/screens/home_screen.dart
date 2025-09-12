import 'package:doctorfriend/components/modal_notifications.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/models/notification_app.dart';
import 'package:doctorfriend/screens/education/educations_screen.dart';
import 'package:doctorfriend/screens/schedule/schedule_screen.dart';
import 'package:doctorfriend/screens/settings/settings_screen.dart';
import 'package:doctorfriend/screens/user/user_screen.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:doctorfriend/services/notificatios/notificatios_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> _screens = [];
  AppUser user = AuthService().currentUser!;

  Future<bool> get _isAuthorized async {
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> _setupInteractedMessage() async {
    if (!await _isAuthorized) return;
    // Get any messages which caused the application to open from
    // a terminated state.
    // RemoteMessage? initialMessage =
    //     await FirebaseMessaging.instance.getInitialMessage();
    // if (initialMessage != null) {
    //   _handleMessage(initialMessage);
    // }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    // FirebaseMessaging.onMessage.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage remoteMessage) async {
    final type = remoteMessage.data['type'];
    final NotificationApp? notification = await NotificationsService()
        .getNotification(id: remoteMessage.data['notificationId'] ?? "");

    if (notification == null) {
      _openNotifications();
      return;
    }

    if (type == 'schedule' ||
        type == 'unschedule' ||
        type == 'evaluation' ||
        type == 'course' ||
        type == 'freeTrialExpiration') {
      _openNotification(notification);
    }
  }

  _openNotification(NotificationApp notification) {
    if (mounted) {
      ModalNotifications.openNotification(context, notification);
    }
  }

  _openNotifications() {
    if (mounted) {
      ModalNotifications(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _setupInteractedMessage();
    _currentIndex = 1;
    _screens = [
      const SettingsScreen(),
      const ScheduleScreen(),
      const EducationsScreen(),
      const UserScreen(),
    ];
    // _getSavedScreen();
  }

  late int _currentIndex;

  void _navigate(int index) async {
    setState(() {
      _currentIndex = index;
    });
    // await Store.saveString("@screen", index.toString());
  }

  // _getSavedScreen() async {
  //   String value = await Store.getString("@screen", "1");

  //   setState(() {
  //     _currentIndex = int.parse(value);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final traslation = Translations.of(context).translate('home_screen');
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        onTap: _navigate,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: colorScheme.onBackground,
        selectedItemColor: colorScheme.secondary,
        unselectedItemColor: colorScheme.onPrimary,
        selectedFontSize: 12.0,
        unselectedFontSize: 10.0,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_applications_sharp),
            label: traslation["menu_settings"],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_month),
            label: traslation["menu_schedule"],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.cast_for_education),
            label: traslation["menu_education"],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_pin_outlined),
            label: traslation["menu_profile"],
          ),
        ],
      ),
    );
  }
}

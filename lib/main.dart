import 'package:doctorfriend/app_routes.dart';
import 'package:doctorfriend/data/store.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/services/users/users_service.dart';
import 'package:doctorfriend/utils/preferences_util.dart';
import 'package:doctorfriend/utils/theme_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:upgrader/upgrader.dart';
import 'firebase_options.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   // print("Handling a background message: ${message.messageId}");
// }

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // await PurchasesApp().initPlatformState();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final RemoteMessage? message =
      await FirebaseMessaging.instance.getInitialMessage();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseAnalytics.instance;
  runApp(MyApp(
    initialRoute: message?.data["route"],
  ));
}

// every day 00:00

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    this.initialRoute,
  });

  final String? initialRoute;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData _currentTheme = ThemeUtil.light();
  String? _currentRoute;
  bool _loading = true;
  AppUser? _appUser;
  Object? _error;
  bool _isPremium = false;

  late Locale _locale;

  void _setLocale(Locale locale) async {
    final currentLocale = Translations.setLocale(locale);
    setState(() {
      _locale = currentLocale;
    });
    await Store.saveString(
      PreferencesUtil.currentLocale,
      "${_locale.languageCode}-${_locale.countryCode}".toLowerCase(),
    );
    if (_appUser != null) {
      await UsersService().updateLocale(userId: _appUser!.id, locale: _locale);
    }
    await FirebaseAuth.instance.setLanguageCode(_locale.languageCode);
  }

  Future<void> _getCurrentLocaleSaved() async {
    Locale deviceLocale = PlatformDispatcher.instance.locale;
    final savedLocaleString = await Store.getString(
      PreferencesUtil.currentLocale,
    );
    if (savedLocaleString.trim() != "") {
      final parts = savedLocaleString.split("-");
      if (parts.length == 2) {
        deviceLocale = Locale(parts[0], parts[1].toUpperCase());
      }
    }
    _setLocale(deviceLocale);
  }

  void _updateTheme(ThemeData theme) {
    setState(() => _currentTheme = theme);
  }

  void _updateCurrentRoute(String route) {
    _currentRoute = route;
  }

  // _paymentStateChanges() {
  //   PurchasesApp().customerInfoChanges.listen((data) async {
  //     final String? plan = PurchasesApp().getPlan;
  //     final isPremium = plan != null;
  //     if (_isPremium != isPremium) {
  //       setState(() => _isPremium = isPremium);
  //     }
  //   });
  // }

  void _userChanges() {
    AuthService().userChanges.listen((data) {
      final appUser = data;
      if (appUser != null && _appUser == null ||
          _appUser?.planType != appUser?.planType) {
        _subscriptionChanges();
      }
      if (appUser?.id != _appUser?.id ||
          _appUser?.isPremium != appUser?.isPremium ||
          _loading ||
          _appUser?.userType != appUser?.userType ||
          _appUser?.userVerified != appUser?.userVerified) {
        _appUser = appUser;
        setState(() => _loading = false);
      } else {
        _appUser = appUser;
      }
      final String? plan = _appUser?.planType;
      final isPremium = plan != null;
      if (_isPremium != isPremium) {
        setState(() => _isPremium = isPremium);
      }
    }).onError((error) {
      setState(() => _error = error);
    });
  }

  void _subscriptionChanges() {
    AuthService().subscriptionChanges.listen((data) {
      if (_appUser == null) return;
      final sub = data;
      AuthService().setSubscription(sub);
      setState(() {});
    }).onError((error) {
      // setState(() => _error = error);
    });
  }

  @override
  void initState() {
    super.initState();
    // _paymentStateChanges();
    _userChanges();
    _locale = Translations.localesAvaliable[0].locale;
    _getCurrentLocaleSaved();
    _currentRoute = widget.initialRoute;
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    /// The route configuration.
    final GoRouter authRouter = AppRoutes.authRouter(
      _currentRoute,
      _updateCurrentRoute,
      _setLocale,
    );
    final GoRouter unauthorizedRouter = AppRoutes.unauthorizedRouter(
      _currentRoute,
      _setLocale,
    );
    final GoRouter loadingRouter = AppRoutes.loadingRouter();
    final GoRouter getPremiumRouter = AppRoutes.getPremiumRouter(
      _currentRoute,
      _updateCurrentRoute,
      _setLocale,
    );

    final GoRouter appRouter = AppRoutes.appRouter(
      currentRoute: _currentRoute,
      updateCurrentRoute: _updateCurrentRoute,
      updateTheme: _updateTheme,
      user: _appUser,
      setLocale: _setLocale,
    );

    GoRouter routerConfig() {
      if (_loading) {
        return loadingRouter;
      }
      if (_error != null) {
        return AppRoutes.errorRouter(_error!, _currentRoute, _setLocale);
      }
      if (_appUser == null) {
        return authRouter;
      }

      if (_appUser!.disabled || _appUser!.isNew) {
        return unauthorizedRouter;
      }
      if (!_appUser!.isPremium && !_isPremium) {
        return getPremiumRouter;
      }

      return appRouter;
    }

    return SafeArea(
      child: MaterialApp.router(
        // color: Colors.amber,
        title: 'Doctor Friend',
        // darkTheme: ThemeUtil.dark(),
        routerConfig: routerConfig(),
        debugShowCheckedModeBanner: false,
        theme: _currentTheme,
        builder: (context, child) {
          return UpgradeAlert(
            navigatorKey: routerConfig().routerDelegate.navigatorKey,
            child: child ?? const Scaffold(),
          );
        },
        // traduzir calendario para portugues
        localizationsDelegates: const [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales:
            Translations.localesAvaliable.map((e) => e.locale).toList(),
        locale: _locale,
      ),
    );
  }
}

// import 'dart:async';
// import 'dart:io' show Platform;

// import 'package:doctorfriend/exeption/handle_exception.dart';
// import 'package:doctorfriend/models/app_user.dart';
// import 'package:doctorfriend/services/auth/auth_service.dart';
// import 'package:doctorfriend/services/purchases/purchases.dart';
// import 'package:doctorfriend/services/traslation/traslation.dart';
// import 'package:flutter/services.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';

// const buildingForAmazon = false;

// class RevenueCatPurchasesApp implements PurchasesApp {
//   final String _lang = Translations.currentLocale.languageCode;
//   @override
//   Future<void> initPlatformState() async {
//     // await Purchases.setLogLevel(LogLevel.debug);

//     PurchasesConfiguration? configuration;
//     if (Platform.isAndroid) {
//       configuration =
//           PurchasesConfiguration("goog_zydyokdhZXcMBchhrVQtzzyUHes");
//       if (buildingForAmazon) {
//         // use your preferred way to determine if this build is for Amazon store
//         // checkout our MagicWeather sample for a suggestion
//         configuration = AmazonConfiguration("goog_zydyokdhZXcMBchhrVQtzzyUHes");
//       }
//     } else if (Platform.isIOS) {
//       configuration =
//           PurchasesConfiguration("appl_MVOOmHTRpQHuGNqwsyvPLpUIzWA");
//     }

//     if (configuration == null) return;
//     await Purchases.configure(configuration);
//   }

//   static CustomerInfo? _currentCustomerInfo;

//   // static String? _premiumPriceString;
//   static Map<String, Offering>? _offerings;

//   @override
//   Map<String, Offering> get offerings {
//     return _offerings ?? {};
//   }

//   @override
//   String? get getPlan {
//     String? res;
//     final activeSubscriptions = _currentCustomerInfo?.activeSubscriptions;
//     if (activeSubscriptions != null && activeSubscriptions.isNotEmpty) {
//       final sub = activeSubscriptions[0];

//       if (sub.contains("premium")) {
//         res = "premium";
//       } else if (sub.contains("gold")) {
//         res = "gold";
//       } else if (sub.contains("basic")) {
//         res = "basic";
//       }
//     }

//     if (res == null) {
//       final currentUser = AuthService().currentUser;
//       if (currentUser != null &&
//           currentUser.isPremium &&
//           currentUser.isPlanValid) {
//         // res = currentUser.subscriptionData?.productPlanIdentifier;
//       }
//     }

//     return res;
//   }

//   static MultiStreamController<CustomerInfo?>? _controller;
//   static final _customerInfoStream =
//       Stream<CustomerInfo?>.multi((controller) async {
//     _controller = controller;
//     _controller?.add(_currentCustomerInfo);
//   });

//   static MultiStreamController<Map<String, Offering>?>? _controllerOfferings;
//   static final _offeringsStream =
//       Stream<Map<String, Offering>?>.multi((controller) async {
//     _controllerOfferings = controller;
//     _controllerOfferings?.add(_offerings);
//   });

//   @override
//   Future<void> listenCustomerInfo(AppUser? user) async {
//     if (user == null) return;

//     await Purchases.logIn(user.id);

//     if (user.firebaseMessagingToken != null) {
//       Purchases.setPushToken(user.firebaseMessagingToken!);
//     }
//     Purchases.setEmail(user.email);
//     Purchases.addCustomerInfoUpdateListener((customerInfo) {
//       _currentCustomerInfo = customerInfo;
//       _controller?.add(_currentCustomerInfo);
//     });
//     loadOfferings();
//     // _premiumPriceString = _offerings?.storeProduct.priceString;
//   }

//   @override
//   CustomerInfo? get currentCustomerInfo {
//     return _currentCustomerInfo;
//   }

//   @override
//   Stream<CustomerInfo?> get customerInfoChanges {
//     return _customerInfoStream;
//   }

//   @override
//   Stream<Map<String, Offering>?> get offeringsChanges {
//     return _offeringsStream;
//   }

//   Future<void> loadOfferings() async {
//     try {
//       final Offerings offerings = await Purchases.getOfferings();
//       _offerings = offerings.all; // ou qualquer pacote desejado
//       _controllerOfferings?.add(_offerings);
//     } catch (error) {
//       print(error);

//       ///
//     }
//   }

//   @override
//   Future<void> bayPremium(Package package) async {
//     try {
//       await Purchases.purchasePackage(package);

//       // O evento purchaseCompleted será chamado automaticamente
//     } on PlatformException catch (e) {
//       // Error fetching customer info
//       var errorCode = PurchasesErrorHelper.getErrorCode(e);
//       if (errorCode == PurchasesErrorCode.productAlreadyPurchasedError) {
//         throw HandleException("already_purchased", _lang);
//       }
//       if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
//         throw HandleException(errorCode.toString(), _lang);
//       }
//     } on HandleException catch (error) {
//       throw HandleException(error.message, _lang);
//     } catch (e) {
//       // throw const HandleException("Erro ao buscar informações do cliente");
//       // O evento purchaseFailed será chamado automaticamente
//     }
//   }
// }

// const _defaltOfferings = {
//   "premium": Offering(
//     "premium",
//     "",
//     {},
//     [],
//     monthly: Package(
//       "",
//       PackageType.monthly,
//       StoreProduct("", "", "Premium", 00, "", ""),
//       PresentedOfferingContext("premium", null, null),
//     ),
//   ),
//   "gold": Offering(
//     "gold",
//     "",
//     {},
//     [],
//     monthly: Package(
//       "",
//       PackageType.monthly,
//       StoreProduct("", "", "gold", 00, "", ""),
//       PresentedOfferingContext("premium", null, null),
//     ),
//   ),
//   "basic": Offering(
//     "basic",
//     "",
//     {},
//     [],
//     monthly: Package(
//       "",
//       PackageType.monthly,
//       StoreProduct("", "", "basic", 00, "", ""),
//       PresentedOfferingContext("premium", null, null),
//     ),
//   ),
// };

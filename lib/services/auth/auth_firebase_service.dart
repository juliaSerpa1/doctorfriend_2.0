// import 'dart:io';
// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:doctorfriend/exeption/firebase_auth_handle_exception.dart';
// import 'package:doctorfriend/exeption/firestore_exception.dart';
// import 'package:doctorfriend/exeption/handle_exception.dart';
// import 'package:doctorfriend/models/address_data.dart';
// import 'package:doctorfriend/models/app_user.dart';
// import 'package:doctorfriend/models/links.dart';
// import 'package:doctorfriend/models/subscription.dart';
// import 'package:doctorfriend/models/upload_stream.dart';
// import 'package:doctorfriend/models/web_user.dart';
// import 'package:doctorfriend/services/auth/auth_service.dart';
// import 'package:doctorfriend/services/subscription/subscription.dart';
// import 'package:doctorfriend/services/traslation/traslation.dart';
// import 'package:doctorfriend/services/users/users_service.dart';
// import 'package:doctorfriend/utils/firebase/firebase_firestore_util.dart';
// import 'package:doctorfriend/utils/firebase/firebase_storage_util.dart';
// import 'package:doctorfriend/utils/firebase/firebase_tables_util.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_timezone/flutter_timezone.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// final String table = FirebaseTablesUtil.users;
// final String tableImages = FirebaseTablesUtil.userImages;
// bool _isLogin = true;

// class AuthFirebaseService implements AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
//   bool isInitialize = false;
//   static AppUser? _currentUser;
//   static User? _authUser;
//   static Subscription? _currentSubscription;
//   static WebUser? _webUser;
//   static bool _toSignup = false;
//   final String _lang = Translations.currentLocale.languageCode;

//   static MultiStreamController<AppUser?>? _controller;
//   static MultiStreamController<Subscription?>? _controllerSubscription;

//   static final _userStream = Stream<AppUser?>.multi((controller) async {
//     final authChanges = FirebaseAuth.instance.authStateChanges();

//     /// The subscription to the stream
//     StreamSubscription? getStationsListSubscription;
//     // AuthService().logout();
//     await for (final user in authChanges) {
//       getStationsListSubscription?.cancel();
//       getStationsListSubscription = null;
//       _authUser = user;
//       if (user != null) {
//         getStationsListSubscription =
//             UsersService().user(user.uid).listen((doc) async {
//           if (doc != null) {
//             _toSignup = false;
//             _currentUser = doc;
//             await _currentUser?.loadAddresses();
//             _currentUser?.setSubscription(_currentSubscription);
//             _controller = controller;
//             _controller?.add(_currentUser);
//             await SubscriptionApp().listenCustomerInfo(_currentUser);
//             if (_isLogin) {
//               refresListenToken(_currentUser);
//               _isLogin = false;
//             }
//           } else {
//             await AuthFirebaseService().logout();
//             _toSignup = true;
//           }
//         });
//       } else {
//         _currentUser = _currentUser;
//         _controller = controller;
//         _controller?.add(_currentUser);
//       }
//     }
//   });

//   static final _subscriptionrStream =
//       Stream<Subscription?>.multi((controller) async {
//     // print("sub");
//     if (_currentUser == null) return;
//     final subscriptionChangesLocal =
//         SubscriptionApp().getSubscription(_currentUser!.id);

//     subscriptionChangesLocal.listen((event) {
//       _currentSubscription = event;
//       _controllerSubscription = controller;
//       _controllerSubscription?.add(_currentSubscription);
//     });
//   });

//   @override
//   AppUser? get currentUser {
//     return _currentUser;
//   }

//   @override
//   User? get authUser {
//     return _authUser;
//   }

//   @override
//   Subscription? get currentSubscription {
//     return _currentSubscription;
//   }

//   @override
//   WebUser? get webUser {
//     return _webUser;
//   }

//   @override
//   Stream<AppUser?> get userChanges {
//     return _userStream;
//   }

//   @override
//   bool get toSignup {
//     return _toSignup;
//   }

//   @override
//   setSubscription(Subscription? sub) {
//     _currentUser?.setSubscription(sub);
//     _controller?.add(_currentUser);
//   }

//   @override
//   Future<void> loadAddresses() async {
//     await _currentUser?.loadAddresses();
//     _controller?.add(_currentUser);
//   }

//   @override
//   Stream<Subscription?> get subscriptionChanges {
//     return _subscriptionrStream;
//   }

//   @override
//   Future<void> updateToAppUser({
//     required String name,
//     required String phone,
//     required String local,
//     required double longitude,
//     required double latitude,
//     required String profession,
//     required String specialty,
//     required String? registerNumber,
//     required String? registerClassOrder,
//     required bool isHealthInsurance,
//     required bool terms,
//     required bool norms,
//   }) async {
//     try {
//       if (_webUser != null) {
//         // await credential.user?.updatePhotoURL(imageUrl);
//         final fcmToken = await FirebaseMessaging.instance.getToken();
//         // 3. salvar usuário no banco de dados (opcional)
//         // 3. salvar usuário no banco de dados (opcional)

//         final address = AddressData(
//           id: "",
//           userId: _webUser!.id,
//           street: null,
//           number: null,
//           complement: null,
//           zipCode: null,
//           neighborhood: null,
//           lat: latitude,
//           lng: longitude,
//           coordinates: null,
//           local: local,
//         );

//         final currentUser = await userToCreate(
//           id: _webUser!.id,
//           name: name,
//           email: _webUser!.email,
//           phone: phone,
//           profession: profession,
//           specialty: specialty,
//           addresses: [address],
//           fcmToken: fcmToken,
//           imageUrl: _webUser!.photoUrl,
//           registerClassOrder: registerClassOrder,
//           registerNumber: registerNumber,
//           isHealthInsurance: isHealthInsurance,
//           currentSubscription: currentSubscription,
//         );

//         await UsersService().addUser(currentUser);
//         await UsersService().addAddress(address);
//       } else {
//         throw HandleException("try_login_with_site_user", _lang);
//       }
//     } on FirebaseAuthException catch (e) {
//       throw FirebaseAuthHandleException(e.code, _lang);
//     }
//   }

//   @override
//   Future<void> signup({
//     required String name,
//     required String email,
//     required String phone,
//     required String? password,
//     required String local,
//     required double longitude,
//     required double latitude,
//     required String profession,
//     required String specialty,
//     required String? registerNumber,
//     required String? registerClassOrder,
//     required bool isHealthInsurance,
//     required bool terms,
//     required bool norms,
//   }) async {
//     try {
//       final signup = await Firebase.initializeApp(
//         name: 'userSignup',
//         options: Firebase.app().options,
//       );

//       final auth = FirebaseAuth.instanceFor(app: signup);

//       if (password == null) return;
//       UserCredential credential = await auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       if (credential.user != null) {
//         // 1. Upload da foto do usuário
//         // final imageName = '${credential.user!.uid}.jpg';
//         // final imageUrl = await _uploadUserImage(image, imageName);

//         // 2. atualizar os atributos do usuário
//         await credential.user?.updateDisplayName(name);
//         await credential.user?.sendEmailVerification();
//         // await credential.user?.updatePhotoURL(imageUrl);
//         String? fcmToken;
//         try {
//           fcmToken = await FirebaseMessaging.instance.getToken();
//         } catch (error) {
//           //
//         }
//         // 3. salvar usuário no banco de dados (opcional)
//         final User user = credential.user!;

//         final address = AddressData(
//           id: "",
//           userId: user.uid,
//           street: null,
//           number: null,
//           complement: null,
//           zipCode: null,
//           neighborhood: null,
//           lat: latitude,
//           lng: longitude,
//           coordinates: null,
//           local: local,
//         );

//         final currentUser = await userToCreate(
//           id: user.uid,
//           name: name,
//           email: user.email!,
//           phone: phone,
//           profession: profession,
//           specialty: specialty,
//           addresses: [address],
//           fcmToken: fcmToken,
//           imageUrl: user.photoURL,
//           registerClassOrder: registerClassOrder,
//           registerNumber: registerNumber,
//           isHealthInsurance: isHealthInsurance,
//           currentSubscription: currentSubscription,
//         );

//         await UsersService().addUser(currentUser);
//         await UsersService().addAddress(address);
//         // 2.5 fazer o login do usuário
//         await login(email, password);
//       }

//       await signup.delete();
//     } on FirebaseAuthException catch (e) {
//       throw FirebaseAuthHandleException(e.code, _lang);
//     }
//   }

//   @override
//   Future<void> editProfile({
//     required String name,
//     required String email,
//     required String password,
//     required String profession,
//     required String specialty,
//     required String? registerClassOrder,
//     required File? image,
//   }) async {
//     try {
//       final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       if (credential.user != null) {
//         User user = credential.user!;
//         // 1. Upload da foto do usuário
//         UploadStream? imageInfo;
//         if (image != null) {
//           final imageName = user.uid;
//           imageInfo = await FirebaseStorageUtil.uploadFile(
//             table: "$tableImages/${user.uid}",
//             file: image,
//             fileName: imageName,
//           );
//           imageInfo.listen(sateChanged: () => {});
//           await imageInfo.awaitFilishe();
//         }
//         await credential.user?.updateDisplayName(name);
//         final Map<String, String?> data = {
//           'name': name,
//           "profession": profession.toLowerCase().trimRight(),
//           "specialty": specialty.toLowerCase().trimRight(),
//           "registerClassOrder": registerClassOrder,
//         };
//         if (imageInfo != null) {
//           data.putIfAbsent(
//             "imageUrl",
//             () => imageInfo!.downloadURL,
//           );
//         }
//         await FirebaseFirestoreUtil.update(
//             table: table, id: user.uid, data: data);
//       }
//     } on FirebaseAuthException catch (e) {
//       throw FirebaseAuthHandleException(e.code, _lang);
//     }
//   }

//   @override
//   Future<void> login(String email, String password) async {
//     try {
//       final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       if (credential.user == null) {
//         throw HandleException("user_not_found", _lang);
//       }
//       final use = await UsersService().getUser(credential.user!.uid);

//       if (use == null) {
//         final userWeb =
//             await UsersService().getUserCustomer(credential.user!.uid);
//         if (userWeb == null) {
//           throw HandleException("user_not_found_in_app", _lang);
//         } else {
//           _webUser = userWeb;
//           throw HandleException("userWeb", _lang);
//         }
//       }

//       _isLogin = true;
//     } on FirebaseAuthException catch (e) {
//       throw FirebaseAuthHandleException(e.code, _lang);
//     }
//   }

//   @override
//   Future<void> logout() async {
//     _currentUser = null;
//     await FirebaseAuth.instance.signOut();
//   }

//   @override
//   Future<void> verifyPasswordResetCode(
//     String code,
//   ) async {
//     try {
//       await FirebaseAuth.instance.verifyPasswordResetCode(code);
//     } on FirebaseAuthException catch (e) {
//       throw FirebaseAuthHandleException(e.code, _lang);
//     }
//   }

//   @override
//   Future<void> resetPassword(
//     String code,
//     String newPassword,
//   ) async {
//     try {
//       await FirebaseAuth.instance.confirmPasswordReset(
//         code: code,
//         newPassword: newPassword,
//       );
//     } on FirebaseAuthException catch (e) {
//       throw FirebaseAuthHandleException(e.code, _lang);
//     }
//   }

//   @override
//   Future<void> sendEmailToResetPassword(String email) async {
//     try {
//       await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
//     } on FirebaseAuthException catch (e) {
//       throw FirebaseAuthHandleException(e.code, _lang);
//     }
//   }

//   @override
//   Future<void> deleteAccount(String email, String password) async {
//     try {
//       // Delete user from Firebase Authentication
//       UserCredential userCredential =
//           await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       if (userCredential.user != null) {
//         User user = userCredential.user!;
//         await user.delete();
//         await logout();
//         // await UsersService().deleteUser(userCredential.user?.uid ?? "");
//         // Delete user's data from Firestore
//       }
//     } on FirebaseAuthException catch (e) {
//       throw FirebaseAuthHandleException(e.code, _lang);
//     } on FirestoreException catch (e) {
//       throw FirestoreException(e.message, _lang);
//     } catch (e) {
//       throw HandleException("unexpected_error", _lang);
//     }
//   }

//   ////////////////
//   ///
//   ///

//   Future<void> initSignIn() async {
//     if (!isInitialize) {
//       await _googleSignIn.initialize(
//         serverClientId:
//             '795953190428-7a8srq13mk1pehl8v6bq1ftq5uhdaq13.apps.googleusercontent.com',
//       );
//     }
//     isInitialize = true;
//   }

//   // Sign in with Google
//   @override
//   Future<UserCredential?> signInWithGoogle() async {
//     try {
//       initSignIn();
//       final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
//       final idToken = googleUser.authentication.idToken;
//       final authorizationClient = googleUser.authorizationClient;
//       GoogleSignInClientAuthorization? authorization = await authorizationClient
//           .authorizationForScopes(['email', 'profile']);
//       final accessToken = authorization?.accessToken;
//       if (accessToken == null) {
//         final authorization2 = await authorizationClient.authorizationForScopes(
//           ['email', 'profile'],
//         );
//         if (authorization2?.accessToken == null) {
//           throw FirebaseAuthException(code: "error", message: "error");
//         }
//         authorization = authorization2;
//       }
//       final credential = GoogleAuthProvider.credential(
//         accessToken: accessToken,
//         idToken: idToken,
//       );
//       final UserCredential userCredential =
//           await FirebaseAuth.instance.signInWithCredential(credential);
//       final User? user = userCredential.user;
//       if (user != null) {
//         final userDoc =
//             FirebaseFirestore.instance.collection('users').doc(user.uid);
//         final docSnapshot = await userDoc.get();
//         if (!docSnapshot.exists) {
//           await userDoc.set({
//             'uid': user.uid,
//             'name': user.displayName ?? '',
//             'email': user.email ?? '',
//             'photoURL': user.photoURL ?? '',
//             'provider': 'google',
//             'createdAt': FieldValue.serverTimestamp(),
//           });
//         }
//       }
//       print("userCredential");
//       print(userCredential);
//       return userCredential;
//     } catch (e) {
//       print('Error: $e');
//       rethrow;
//     }
//   }

//   // Sign out
//   Future<void> signOut() async {
//     try {
//       await _googleSignIn.signOut();
//       await _auth.signOut();
//     } catch (e) {
//       print('Error signing out: $e');
//       throw e;
//     }
//   }

//   // Get current user
//   User? getCurrentUser() {
//     return _auth.currentUser;
//   }
// }

// void refresListenToken(AppUser? currentUser) async {
//   try {
//     if (currentUser != null) {
//       final fcmToke = await FirebaseMessaging.instance.getToken();
//       if (currentUser.firebaseMessagingToken != fcmToke && fcmToke != null) {
//         return await updateToken(currentUser, fcmToke);
//       }

//       FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
//         if (currentUser.firebaseMessagingToken != fcmToken) {
//           await updateToken(currentUser, fcmToken);
//         }
//       }).onError((err) {
//         // Error getting token.
//       });
//     }
//   } catch (error) {
//     //
//   }
// }

// Future<void> updateToken(AppUser currentUser, String fcmToken) async {
//   await FirebaseFirestoreUtil.update(
//     table: table,
//     id: currentUser.id,
//     data: {
//       'firebaseMessagingToken': fcmToken,
//       "deviceType": getDeviceType(),
//     },
//   );
// }

// String getDeviceType() {
//   if (Platform.isAndroid) {
//     return 'Android';
//   } else if (Platform.isIOS) {
//     return 'iOS';
//   }
//   return 'Unknown';
// }

// Future<AppUser> userToCreate({
//   required String id,
//   required String name,
//   required String email,
//   required String phone,
//   required String profession,
//   required String specialty,
//   required List<AddressData> addresses,
//   required String? fcmToken,
//   required String? imageUrl,
//   required String? registerNumber,
//   required String? registerClassOrder,
//   required bool isHealthInsurance,
//   required Subscription? currentSubscription,
// }) async {
//   return AppUser(
//     id: id,
//     name: name,
//     terms: DateTime.now(),
//     norms: DateTime.now(),
//     email: email,
//     phone: phone,
//     userVerified: false,
//     addresses: addresses,
//     profession: profession,
//     isHealthInsurance: isHealthInsurance,
//     specialty: specialty,
//     commercialPhone: null,
//     registerNumber: registerNumber,
//     registerClassOrder: registerClassOrder,
//     pix: null,
//     services: [],
//     experiences: [],
//     diseasesTreated: [],
//     healthInsurance: [],
//     languages: [],
//     trainings: [],
//     commonQuestion: [],
//     galery: [],
//     aboutMe: null,
//     freeTrialExpirationDate: DateTime.now().add(const Duration(days: 30)),
//     freeTrialEducationExpirationDate:
//         DateTime.now().add(const Duration(days: 60)),
//     subscriptionData: currentSubscription,
//     links: const Links(
//       facebook: null,
//       site: null,
//       instagram: null,
//       twitter: null,
//     ),
//     shopping: [],
//     localeName: Platform.localeName.toLowerCase(),
//     timeZone: await FlutterTimezone.getLocalTimezone(),
//     firebaseMessagingToken: fcmToken,
//     deviceType: getDeviceType(),
//     imageUrl: imageUrl,
//     userState: UserState.activated,
//     userType: UserType.underAnalysis,
//     updatedDate: DateTime.now(),
//     createdDate: DateTime.now(),
//   );
// }

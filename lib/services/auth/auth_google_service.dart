import 'dart:io';
import 'dart:async';
import 'package:doctorfriend/exeption/firebase_auth_handle_exception.dart';
import 'package:doctorfriend/exeption/firestore_exception.dart';
import 'package:doctorfriend/exeption/handle_exception.dart';
import 'package:doctorfriend/models/address_data.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/models/links.dart';
import 'package:doctorfriend/models/phone.dart';
import 'package:doctorfriend/models/subscription.dart';
import 'package:doctorfriend/models/upload_stream.dart';
import 'package:doctorfriend/models/web_user.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:doctorfriend/services/subscription/subscription.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/services/users/users_service.dart';
import 'package:doctorfriend/utils/firebase/firebase_firestore_util.dart';
import 'package:doctorfriend/utils/firebase/firebase_storage_util.dart';
import 'package:doctorfriend/utils/firebase/firebase_tables_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

final String table = FirebaseTablesUtil.users;
final String tableImages = FirebaseTablesUtil.userImages;

class AuthGoogleService implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool isInitialize = false;
  static AppUser? _currentUser;
  static User? _authUser;
  static String _authUserName = "";
  static Subscription? _currentSubscription;
  static WebUser? _webUser;
  static bool _toSignup = false;
  final String _lang = Translations.currentLocale.languageCode;

  static MultiStreamController<AppUser?>? _controller;
  static MultiStreamController<Subscription?>? _controllerSubscription;

  static final _userStream = Stream<AppUser?>.multi((controller) async {
    final authChanges = FirebaseAuth.instance.authStateChanges();

    /// The subscription to the stream
    StreamSubscription? gasStationsListSubscription;
    // AuthService().logout();
    await for (final user in authChanges) {
      _authUser = user;

      gasStationsListSubscription?.cancel();
      gasStationsListSubscription = null;
      if (user != null) {
        gasStationsListSubscription =
            UsersService().user(user.uid).listen((doc) async {
          _authUserName = doc?.name ?? "";
          if (doc != null && doc.specialty.isNotEmpty) {
            _toSignup = false;
            _currentUser = doc;
            await _currentUser?.loadAddresses();
            await _currentUser?.loadProfession();
            _currentUser?.setSubscription(_currentSubscription);
            _controller = controller;
            _controller?.add(_currentUser);
            await SubscriptionApp().listenCustomerInfo(_currentUser);
            refresListenToken(_currentUser);
          } else {
            _toSignup = true;
            _currentUser = _currentUser;
            _controller = controller;
            _controller?.add(_currentUser);
          }
        });
      } else {
        _currentUser = _currentUser;
        _controller = controller;
        _controller?.add(_currentUser);
      }
    }
  });

  static final _subscriptionrStream =
      Stream<Subscription?>.multi((controller) async {
    // print("sub");
    if (_currentUser == null) return;
    final subscriptionChangesLocal =
        SubscriptionApp().getSubscription(_currentUser!.id);

    subscriptionChangesLocal.listen((event) {
      _currentSubscription = event;
      _controllerSubscription = controller;
      _controllerSubscription?.add(_currentSubscription);
    });
  });

  @override
  AppUser? get currentUser {
    return _currentUser;
  }

  @override
  User? get authUser {
    return _authUser;
  }

  @override
  Subscription? get currentSubscription {
    return _currentSubscription;
  }

  @override
  WebUser? get webUser {
    return _webUser;
  }

  @override
  Stream<AppUser?> get userChanges {
    return _userStream;
  }

  @override
  bool get toSignup {
    return _toSignup;
  }

  @override
  setSubscription(Subscription? sub) {
    _currentUser?.setSubscription(sub);
    _controller?.add(_currentUser);
  }

  @override
  Future<void> loadAddresses() async {
    await _currentUser?.loadAddresses();
    _controller?.add(_currentUser);
  }

  @override
  Stream<Subscription?> get subscriptionChanges {
    return _subscriptionrStream;
  }

  @override
  Future<void> signup({
    required String? name,
    required String phone,
    required String local,
    required double longitude,
    required double latitude,
    required String profession,
    required String specialty,
    required String? registerNumber,
    required String? registerClassOrder,
    required bool isHealthInsurance,
    required bool terms,
    required bool norms,
  }) async {
    try {
      if (_authUser != null) {
        String? fcmToken;
        try {
          fcmToken = await FirebaseMessaging.instance.getToken();
        } catch (error) {
          //
        }
        // 3. salvar usuário no banco de dados (opcional)
        final User user = _authUser!;

        final address = AddressData(
          id: "",
          userId: user.uid,
          street: null,
          number: null,
          complement: null,
          zipCode: null,
          neighborhood: null,
          lat: latitude,
          lng: longitude,
          coordinates: null,
          local: local,
        );

        final currentUser = await userToCreate(
          id: user.uid,
          name: name ?? _authUserName,
          email: user.email!,
          phone: phone,
          profession: profession,
          specialty: specialty,
          addresses: [address],
          fcmToken: fcmToken,
          imageUrl: user.photoURL,
          registerClassOrder: registerClassOrder,
          registerNumber: registerNumber,
          isHealthInsurance: isHealthInsurance,
          currentSubscription: currentSubscription,
        );

        await UsersService().addUser(currentUser);
        await UsersService().addAddress(address);
        // print("SUCESSO ---------------------------------");
        // 2.5 fazer o login do usuário
        // await login(email, password);
      }

      // await signup.delete();
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthHandleException(e.code, _lang);
    }
  }

  @override
  Future<void> editProfile({
    required String name,
    required String profession,
    required String specialty,
    required String? registerClassOrder,
    required File? image,
  }) async {
    try {
      if (_authUser != null) {
        User user = _authUser!;
        // 1. Upload da foto do usuário
        UploadStream? imageInfo;
        if (image != null) {
          final imageName = user.uid;
          imageInfo = await FirebaseStorageUtil.uploadFile(
            table: "$tableImages/${user.uid}",
            file: image,
            fileName: imageName,
          );
          imageInfo.listen(sateChanged: () => {});
          await imageInfo.awaitFilishe();
        }
        await _authUser?.updateDisplayName(name);
        final Map<String, dynamic> data = {
          'name': name,
          "profession": [profession],
          "specialty": [specialty],
          "registerClassOrder": registerClassOrder,
        };
        if (imageInfo != null) {
          data.putIfAbsent(
            "imageUrl",
            () => imageInfo!.downloadURL,
          );
        }
        await FirebaseFirestoreUtil.update(
            table: table, id: user.uid, data: data);
      }
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthHandleException(e.code, _lang);
    }
  }

  // @override
  // Future<void> signInWithGoogle() async {
  //   await GoogleSignIn.instance.authenticate();
  // }

  @override
  Future<void> logout() async {
    _currentUser = null;
    _authUser = null;
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  @override
  Future<void> verifyPasswordResetCode(
    String code,
  ) async {
    try {
      await FirebaseAuth.instance.verifyPasswordResetCode(code);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthHandleException(e.code, _lang);
    }
  }

  @override
  Future<void> resetPassword(
    String code,
    String newPassword,
  ) async {
    try {
      await FirebaseAuth.instance.confirmPasswordReset(
        code: code,
        newPassword: newPassword,
      );
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthHandleException(e.code, _lang);
    }
  }

  @override
  Future<void> sendEmailToResetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthHandleException(e.code, _lang);
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      // Delete user from Firebase Authentication
      final AppUser? currentUserLogged = _currentUser;
      if (_authUser != null) {
        User user = _authUser!;
        if (user.email != currentUserLogged?.email) {
          throw HandleException("wrong_user", _lang);
        }
        await user.delete();
        await logout();
        // await UsersService().deleteUser(userCredential.user?.uid ?? "");
        // Delete user's data from Firestore
      }
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthHandleException(e.code, _lang);
    } on FirestoreException catch (e) {
      throw FirestoreException(e.message, _lang);
    } on HandleException catch (_) {
      await logout();
      rethrow;
    } catch (e) {
      throw HandleException("unexpected_error", _lang);
    }
  }

  ////////////////
  ///
  ///

  Future<void> initSignIn() async {
    if (!isInitialize) {
      await _googleSignIn.initialize(
        serverClientId:
            '795953190428-7a8srq13mk1pehl8v6bq1ftq5uhdaq13.apps.googleusercontent.com',
      );
    }
    isInitialize = true;
  }

  // Sign in with Google
  @override
  Future<UserCredential?> signInWithGoogle() async {
    try {
      await initSignIn();
      // final GoogleSignIn signIn = GoogleSignIn.instance;

      final GoogleSignInAccount googleUser =
          await _googleSignIn.authenticate(); //await signIn
      //   .attemptLightweightAuthentication(); await _googleSignIn.authenticate();
      // if (googleUser == null) {
      //   throw FirebaseAuthHandleException("canceled", _lang);
      // }
      final idToken = googleUser.authentication.idToken;
      final authorizationClient = googleUser.authorizationClient;
      GoogleSignInClientAuthorization? authorization = await authorizationClient
          .authorizationForScopes(['email', 'profile']);
      final accessToken = authorization?.accessToken;
      if (accessToken == null) {
        final authorization2 = await authorizationClient.authorizationForScopes(
          ['email', 'profile'],
        );
        if (authorization2?.accessToken == null) {
          throw FirebaseAuthException(code: "error", message: "error");
        }
        authorization = authorization2;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential;
    } on GoogleSignInException catch (e) {
      throw FirebaseAuthHandleException(e.code.name, _lang);
    } on FirebaseAuthHandleException catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // // Sign in with Google
  // @override
  // Future<UserCredential?> signInWithApple() async {
  //   try {
  //     if (Platform.isIOS) {
  //       // iOS: fluxo nativo
  //       final appleCredential = await SignInWithApple.getAppleIDCredential(
  //         scopes: [
  //           AppleIDAuthorizationScopes.email,
  //           AppleIDAuthorizationScopes.fullName,
  //         ],

  //         // Obrigatório no Android e Web
  //         webAuthenticationOptions: Platform.isAndroid
  //             ? WebAuthenticationOptions(
  //                 clientId:
  //                     "br.com.doctorfriend.siwa", // Service ID criado na Apple
  //                 redirectUri: Uri.parse(
  //                   "https://doctor-friend-74a87.firebaseapp.com/__/auth/handler",
  //                 ),
  //               )
  //             : null,
  //       );
  //       // print("appleCredential");
  //       // print(appleCredential);
  //       // print(appleCredential.familyName);
  //       // print(appleCredential.givenName);
  //       final oauthCredential = OAuthProvider("apple.com").credential(
  //         idToken: appleCredential.identityToken,
  //         accessToken: appleCredential.authorizationCode,
  //       );

  //       print(oauthCredential.appleFullPersonName);
  //       print(appleCredential.givenName);
  //       print(appleCredential.familyName);
  //       return await FirebaseAuth.instance
  //           .signInWithCredential(oauthCredential);
  //     } else if (Platform.isAndroid) {
  //       // Android: usa Firebase OAuth (evita missing initial state)
  //       final appleCredential = await FirebaseAuth.instance.signInWithProvider(
  //           OAuthProvider("apple.com").setScopes(["email", "name"]));

  //       return appleCredential;
  //       // return await FirebaseAuthOAuth().openSignInFlow(
  //       //   "apple.com",
  //       //   ["email", "name"],
  //       //   {},
  //       // );
  //     } else {
  //       throw UnimplementedError("Plataforma não suportada");
  //     }
  //   } on SignInWithAppleAuthorizationException catch (e) {
  //     // print(e.message);
  //     throw FirebaseAuthHandleException(e.code.name, _lang);
  //   } on FirebaseAuthHandleException catch (_) {
  //     rethrow;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  @override
  Future<User?> signInWithApple() async {
    try {
      OAuthCredential? oauthCredential;
      String? fullName;
      String? email;
      User? user;
      if (Platform.isIOS) {
        // iOS: fluxo nativo
        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );

        fullName = (appleCredential.givenName != null ||
                appleCredential.familyName != null)
            ? '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'
                .trim()
            : null;
        email = appleCredential.email;

        oauthCredential = OAuthProvider("apple.com").credential(
          idToken: appleCredential.identityToken,
          accessToken: appleCredential.authorizationCode,
        );
      } else if (Platform.isAndroid) {
        // Android: usa Firebase OAuth
        final appleCredential = await FirebaseAuth.instance.signInWithProvider(
          OAuthProvider("apple.com").setScopes(["email", "name"]),
        );

        user = appleCredential.user;
        fullName = null; // No Android, a Apple não retorna nome
        email = null;
      } else {
        throw UnimplementedError("Plataforma não suportada");
      }

      if (oauthCredential != null) {
        final userCredential =
            await _auth.signInWithCredential(oauthCredential);
        user = userCredential.user;
      }

      if (user != null) {
        final store = FirebaseFirestoreUtil.store;
        final userDoc =
            store.collection(FirebaseTablesUtil.users).doc(user.uid);
        final snapshot = await userDoc.get();

        if (!snapshot.exists) {
          // Primeiro login: salva name e email
          await userDoc.set({
            'name': fullName ?? '', // fallback se não vier nome
            'email': email ?? user.email,
            "userState": UserState.activated.index,
            "userType": UserType.approved.index,
          });
        }
      }

      return user;
    } on SignInWithAppleAuthorizationException catch (e) {
      // print(e.message);
      throw FirebaseAuthHandleException(e.code.name, _lang);
    } on FirebaseAuthHandleException catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}

void refresListenToken(AppUser? currentUser) async {
  try {
    if (currentUser != null) {
      final fcmToke = await FirebaseMessaging.instance.getToken();
      if (currentUser.firebaseMessagingToken != fcmToke && fcmToke != null) {
        return await updateToken(currentUser, fcmToke);
      }

      FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
        if (currentUser.firebaseMessagingToken != fcmToken) {
          await updateToken(currentUser, fcmToken);
        }
      }).onError((err) {
        // Error getting token.
      });
    }
  } catch (error) {
    //
  }
}

Future<void> updateToken(AppUser currentUser, String fcmToken) async {
  await FirebaseFirestoreUtil.update(
    table: table,
    id: currentUser.id,
    data: {
      'firebaseMessagingToken': fcmToken,
      "deviceType": getDeviceType(),
    },
  );
}

String getDeviceType() {
  if (Platform.isAndroid) {
    return 'Android';
  } else if (Platform.isIOS) {
    return 'iOS';
  }
  return 'Unknown';
}

Future<AppUser> userToCreate({
  required String id,
  required String name,
  required String email,
  required String phone,
  required String profession,
  required String specialty,
  required List<AddressData> addresses,
  required String? fcmToken,
  required String? imageUrl,
  required String? registerNumber,
  required String? registerClassOrder,
  required bool isHealthInsurance,
  required Subscription? currentSubscription,
}) async {
  return AppUser(
    id: id,
    name: name,
    terms: DateTime.now(),
    norms: DateTime.now(),
    email: email,
    phones: [Phone(number: phone, verified: false)],
    userVerified: false,
    addresses: addresses,
    profession: [profession],
    isHealthInsurance: isHealthInsurance,
    specialty: [specialty],
    registerNumber: registerNumber,
    registerClassOrder: registerClassOrder,
    pix: null,
    services: [],
    experiences: [],
    diseasesTreated: [],
    healthInsurance: [],
    languages: [],
    trainings: [],
    commonQuestion: [],
    galery: [],
    aboutMe: null,
    freeTrialExpirationDate: DateTime.now().add(const Duration(days: 30)),
    freeTrialEducationExpirationDate:
        DateTime.now().add(const Duration(days: 60)),
    subscriptionData: currentSubscription,
    links: const Links(
      facebook: null,
      site: null,
      instagram: null,
      twitter: null,
    ),
    shopping: [],
    localeName: Platform.localeName.toLowerCase(),
    timeZone: await FlutterTimezone.getLocalTimezone(),
    firebaseMessagingToken: fcmToken,
    deviceType: getDeviceType(),
    imageUrl: imageUrl,
    userState: UserState.activated,
    userType: UserType.approved,
    updatedDate: DateTime.now(),
    createdDate: DateTime.now(),
  );
}

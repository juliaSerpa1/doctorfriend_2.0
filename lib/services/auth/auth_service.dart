import 'dart:io';

import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/models/subscription.dart';
import 'package:doctorfriend/models/web_user.dart';
import 'package:doctorfriend/services/auth/auth_google_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthService {
  AppUser? get currentUser;

  User? get authUser;
  Subscription? get currentSubscription;
  WebUser? get webUser;

  Stream<AppUser?> get userChanges;
  bool get toSignup;

  Stream<Subscription?> get subscriptionChanges;

  Future<void> loadAddresses();

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
  });
  Future<void> editProfile({
    required String name,
    required String profession,
    required String specialty,
    required String? registerClassOrder,
    required File? image,
  });

  Future<void> signInWithGoogle();
  Future<void> signInWithApple();

  void setSubscription(Subscription? sub);

  Future<void> deleteAccount();

  Future<void> logout();

  Future<void> resetPassword(
    String code,
    String newPassword,
  );

  Future<void> sendEmailToResetPassword(String email);

  Future<void> verifyPasswordResetCode(String code);

  factory AuthService() {
    return AuthGoogleService();
  }
}

import 'package:doctorfriend/models/address_data.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/models/common_question.dart';
import 'package:doctorfriend/models/user_service.dart';
import 'package:doctorfriend/models/verification.dart';
import 'package:doctorfriend/models/web_user.dart';
import 'package:doctorfriend/services/users/users_firebase_service.dart';
import 'package:flutter/material.dart';

abstract class UsersService {
  Stream<List<AppUser>> users();
  Stream<List<AppUser>> usersDesabled();
  Stream<AppUser?> user(String userId);
  Stream<AppUser?> getUserByEmail(String email);

  Future<void> addUser(AppUser user);
  Future<void> setVerification(Verification verification);
  Future<void> addAddress(AddressData address);
  Future<AppUser?> getUser(String userId);
  Future<WebUser?> getUserCustomer(String userId);
  Future<List<AddressData>> getAddresses(String userId);

  Future<void> updateUserContact({
    required String userId,
    required String phone,
    required String commercialPhone,
    required String registerNumber,
    required String pix,
  });

  Future<void> updateUserLinks({
    required String userId,
    required String site,
    required String facebook,
    required String instagram,
    required String twitter,
  });

  Future<void> updateUserServices({
    required String userId,
    required List<UserService> services,
  });

  Future<void> updateLocale({
    required String userId,
    required Locale locale,
  });

  Future<void> updateUserExperiences({
    required String userId,
    required List<String> experiences,
  });

  Future<void> updateUserTimeZone({
    required String userId,
    required String timeZone,
  });

  Future<void> deleteUser(String userId);

  Future<void> updateUserDiseasesTreated({
    required String userId,
    required List<String> diseasesTreated,
  });

  Future<void> updateUserHealthInsurance({
    required String userId,
    required List<String> healthInsurance,
  });

  Future<void> updateUserLanguages({
    required String userId,
    required List<String> languages,
  });

  Future<void> updateUserAboutMe({
    required String userId,
    required String aboutMe,
  });

  Future<void> updateUserTrainings({
    required String userId,
    required List<String> trainings,
  });

  Future<void> updateUserAddresses({
    required AddressData address,
  });

  Future<void> updateUserGalery({
    required String userId,
    required List<String> galery,
  });

  Future<void> updateUserCommonQuestion({
    required String userId,
    required List<CommonQuestion> commonQuestions,
  });

  Future<void> toogleUserState({
    required String userId,
    required UserState userState,
    required UserType userType,
  });

  Future<void> updateUserType({
    required String userId,
    required UserType userType,
  });

  Future<void> updateCityOfOperation({
    required String userId,
    required String local,
    required double latitude,
    required double longitude,
  });

  factory UsersService() {
    return UserFirebaseService();
  }
}

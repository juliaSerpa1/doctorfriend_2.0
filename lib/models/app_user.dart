import 'package:doctorfriend/models/address_data.dart';
import 'package:doctorfriend/models/common_question.dart';
import 'package:doctorfriend/models/links.dart';
import 'package:doctorfriend/models/phone.dart';
import 'package:doctorfriend/models/profession.dart';
import 'package:doctorfriend/models/shopping.dart';
import 'package:doctorfriend/models/subscription.dart';
import 'package:doctorfriend/models/user_service.dart';
import 'package:doctorfriend/services/appData/suggestions_firebase_service.dart';
import 'package:doctorfriend/services/users/users_service.dart';
import 'package:doctorfriend/utils/formater_util.dart';
import 'package:doctorfriend/utils/tools_util.dart';

enum UserState {
  activated,
  disabled,
}

enum UserType {
  approved,
  underAnalysis,
  disapproved,
}

class AppUser {
  final String id;
  final String name;
  final String email;
  final List<Phone> phones;
  final List<String> profession;
  final List<String> specialty;
  final bool isHealthInsurance;
  final bool userVerified;

  final List<AddressData> addresses;

  final String? registerNumber;
  final String? registerClassOrder;
  final String? pix;

  final List<UserService> services;
  final List<String> experiences;
  final List<String> diseasesTreated;
  final List<String> healthInsurance;
  final List<String> languages;
  final List<String> trainings;
  final String? aboutMe;
  final List<String> galery;
  final List<CommonQuestion> commonQuestion;
  final Links links;

  final String? firebaseMessagingToken;
  final String? deviceType;
  final String? imageUrl;
  final String localeName;
  final String timeZone;
  final UserState userState;
  final UserType userType;
  final DateTime updatedDate;
  final DateTime createdDate;
  final DateTime terms;
  final DateTime norms;
  final DateTime freeTrialExpirationDate;
  final DateTime? freeTrialEducationExpirationDate;
  Profession? _profession;

  Subscription? subscriptionData;
  //"shopping" para compras permanentes de produtos
  //'Não foi adicionado nenhum produto ate agora'
  final List<Shopping> shopping;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phones,
    required this.userVerified,
    required this.profession,
    required this.isHealthInsurance,
    required this.specialty,
    required this.registerNumber,
    required this.registerClassOrder,
    required this.pix,
    required this.services,
    required this.experiences,
    required this.diseasesTreated,
    required this.healthInsurance,
    required this.languages,
    required this.trainings,
    required this.aboutMe,
    required this.galery,
    required this.commonQuestion,
    required this.links,
    required this.firebaseMessagingToken,
    required this.deviceType,
    required this.imageUrl,
    required this.userState,
    required this.userType,
    required this.localeName,
    required this.timeZone,
    required this.updatedDate,
    required this.createdDate,
    required this.terms,
    required this.norms,
    required this.subscriptionData,
    required this.shopping,
    required this.freeTrialExpirationDate,
    required this.freeTrialEducationExpirationDate,
    required this.addresses,
  });

  loadAddresses() async {
    final addressesLoaded = await UsersService().getAddresses(id);
    if (addressesLoaded.isEmpty) return;

    addresses.clear();
    addresses.addAll([...addressesLoaded]);
  }

  setSubscription(Subscription? sub) {
    subscriptionData = sub;
  }

  bool get isPremium {
    if (subscriptionData != null &&
        subscriptionData?.currentPeriodEnd != null) {
      return isPlanValid || isFreePlan;
    }

    return isFreePlan;
  }

  bool get isPlanValid {
    return subscriptionData?.currentPeriodEnd
            .toUtc()
            .isAfter(DateTime.now().toUtc()) ??
        false;
  }

  String? get planType {
    if (subscriptionData != null &&
        subscriptionData!.items.isNotEmpty &&
        isPlanValid) {
      return subscriptionData?.items[0].name.toLowerCase();
    }
    return null;
  }

  String? get planTypeFormated {
    if (planType == 'masterclass') {
      return "MasterClass";
    }
    return FormaterUtil.capitalize(planType ?? "");
  }

  bool get isMasterClass {
    return planType == 'masterclass' && isPlanValid;
  }

  bool get isGold {
    return planType == 'premium' ||
        planType == 'gold' ||
        isFreePlan ||
        planType == 'masterclass';
  }

  bool userPermited(UserType userTypeLimit) {
    if (userState == UserState.disabled) return false;

    if (userType.index <= userTypeLimit.index) return true;

    return false;
  }

  bool get disabled {
    return userType == UserType.disapproved;
  }

  bool get isNew {
    return userType == UserType.underAnalysis && !disabled;
  }

  bool get isFreePlan {
    return isFreePlanLesftDays >= 0;
  }

  String? get stripeUrl {
    return subscriptionData?.stripeLink;
  }

  int get isFreePlanLesftDays {
    final date = freeTrialExpirationDate;
    return date.difference(ToolsUtil.startDay()).inDays;
  }

  Future<void> loadProfession() async {
    try {
      final data = await AppDataFirebaseService().getProfessions();
      _profession = data.firstWhere((val) => val.id == profession[0]);
      _profession?.fieldsOfPractice
          .removeWhere((val) => val.id != specialty[0]);
    } catch (_) {}
  }

  Profession? get getProfession {
    return _profession;
  }

  String get phone {
    return phones.isNotEmpty ? phones[0].number : "";
  }

  String get commercialPhone {
    return phones.length == 2 ? phones[1].number : "";
  }
}

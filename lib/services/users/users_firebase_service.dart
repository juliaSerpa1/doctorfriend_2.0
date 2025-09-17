import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorfriend/exeption/firestore_exception.dart';
import 'package:doctorfriend/models/address_data.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/models/common_question.dart';
import 'package:doctorfriend/models/coordinates.dart';
import 'package:doctorfriend/models/links.dart';
import 'package:doctorfriend/models/phone.dart';
import 'package:doctorfriend/models/shopping.dart';
import 'package:doctorfriend/models/user_service.dart';
import 'package:doctorfriend/models/verification.dart';
import 'package:doctorfriend/models/web_user.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/services/users/users_service.dart';
import 'package:doctorfriend/utils/firebase/firebase_firestore_util.dart';
import 'package:doctorfriend/utils/firebase/firebase_tables_util.dart';
import 'package:doctorfriend/utils/formater_util.dart';
import 'package:flutter/material.dart';

class UserFirebaseService implements UsersService {
  final String table = FirebaseTablesUtil.users;
  final String tableVerification = FirebaseTablesUtil.verification;
  final String tableAddresses = FirebaseTablesUtil.addresses;
  final String tableUserCustomer = FirebaseTablesUtil.userCustomer;
  final store = FirebaseFirestoreUtil.store;
  final String _lang = Translations.currentLocale.languageCode;
  @override
  Stream<List<AppUser>> users() {
    final snapshots = store
        .collection(table)
        .withConverter(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        )
        .where("userState", isEqualTo: 0)
        .orderBy('userType')
        .snapshots();

    return snapshots.map((snapshot) {
      return snapshot.docs.map((doc) {
        return doc.data();
      }).toList();
    });
  }

  @override
  Stream<List<AppUser>> usersDesabled() {
    final snapshots = store
        .collection(table)
        .withConverter(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        )
        .where("userState", isEqualTo: 1)
        .orderBy('userType')
        .snapshots();

    return snapshots.map((snapshot) {
      return snapshot.docs.map((doc) {
        return doc.data();
      }).toList();
    });
  }

  @override
  Future<void> addUser(AppUser user) async {
    try {
      final docRef = store.collection(table).doc(user.id);

      // final fcmToken = await FirebaseMessaging.instance.getToken();

      return await docRef.set(_toFirestore(user, null, true));
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, _lang);
    }
  }

  @override
  Future<void> setVerification(Verification verification) async {
    try {
      final docRef = store.collection(tableVerification).doc(verification.id);

      await docRef.set(verification.toMap);
      await _updateUserVerification(
        userId: verification.id,
        verified: true,
      );
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, _lang);
    }
  }

  @override
  Future<void> addAddress(AddressData address) async {
    try {
      final docRef = store.collection(tableAddresses);

      await docRef.add(_toFirestoreAddress(address, null));
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, _lang);
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      await store.collection(table).doc(userId).delete();
      await store
          .collection(FirebaseTablesUtil.stickyNotes)
          .doc(userId)
          .delete();
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, _lang);
    }
  }

  @override
  Stream<AppUser?> user(String userId) {
    final snapshots = store
        .collection(table)
        .doc(userId)
        .withConverter(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        )
        .snapshots();

    return snapshots.map((snapshot) {
      return snapshot.data();
    });
  }

  @override
  Stream<AppUser?> getUserByEmail(String email) {
    final snapshots = store
        .collection(table)
        .where("email", isEqualTo: email)
        .limit(1) // garante que só traga um usuário
        .withConverter<AppUser>(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        )
        .snapshots();

    return snapshots.map((query) {
      if (query.docs.isNotEmpty) {
        return query.docs.first.data();
      }
      return null;
    });
  }

  @override
  Future<AppUser?> getUser(String userId) async {
    final snapshots = await store
        .collection(table)
        .doc(userId)
        .withConverter(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        )
        .get();

    return snapshots.data();
  }

  @override
  Future<List<AddressData>> getAddresses(String userId) async {
    final results = await store
        .collection(tableAddresses)
        .withConverter(
          fromFirestore: _fromFirestoreAddress,
          toFirestore: _toFirestoreAddress,
        )
        .where("userId", isEqualTo: userId)
        .get();

    final list = results.docs.map((doc) => doc.data()).toList();
    return list;
  }

  @override
  Future<WebUser?> getUserCustomer(String userId) async {
    final snapshots = await store
        .collection(tableUserCustomer)
        .doc(userId)
        .withConverter(
          fromFirestore: _fromFirestoreWebUser,
          toFirestore: _toFirestoreWebUser,
        )
        .get();

    return snapshots.data();
  }

  @override
  Future<void> updateUserContact({
    required String userId,
    required String phone,
    required String commercialPhone,
    required String registerNumber,
    required String pix,
  }) async {
    try {
      await FirebaseFirestoreUtil.update(
        table: table,
        id: userId,
        data: {
          'phones': [
            Phone(number: phone, verified: false).toMap,
            Phone(number: commercialPhone, verified: false).toMap
          ],
          'registerNumber': registerNumber,
          'pix': pix,
          'updatedDate': Timestamp.now(),
        },
      );
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, _lang);
    }
  }

  @override
  Future<void> updateUserLinks({
    required String userId,
    required String site,
    required String facebook,
    required String instagram,
    required String twitter,
  }) async {
    try {
      await FirebaseFirestoreUtil.update(
        table: table,
        id: userId,
        data: {
          'links': {
            "site": site,
            "facebook": facebook,
            "instagram": instagram,
            "twitter": twitter,
          },
          'updatedDate': Timestamp.now(),
        },
      );
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, _lang);
    }
  }

  @override
  Future<void> updateUserServices({
    required String userId,
    required List<UserService> services,
  }) async {
    try {
      await FirebaseFirestoreUtil.update(
        table: table,
        id: userId,
        data: {
          'services': services.map((e) => e.toMap).toList(),
          'updatedDate': Timestamp.now(),
        },
      );
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, _lang);
    }
  }

  Future<void> _updateUserVerification({
    required String userId,
    required bool verified,
  }) async {
    try {
      await FirebaseFirestoreUtil.update(
        table: table,
        id: userId,
        data: {
          'userVerified': verified,
        },
      );
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, _lang);
    }
  }

  @override
  Future<void> updateUserExperiences({
    required String userId,
    required List<String> experiences,
  }) async {
    try {
      await FirebaseFirestoreUtil.update(
        table: table,
        id: userId,
        data: {
          'experiences': experiences,
          'updatedDate': Timestamp.now(),
        },
      );
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, _lang);
    }
  }

  @override
  Future<void> updateUserDiseasesTreated({
    required String userId,
    required List<String> diseasesTreated,
  }) async {
    try {
      await FirebaseFirestoreUtil.update(
        table: table,
        id: userId,
        data: {
          'diseasesTreated': diseasesTreated,
          'updatedDate': Timestamp.now(),
        },
      );
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, _lang);
    }
  }

  @override
  Future<void> updateUserHealthInsurance({
    required String userId,
    required List<String> healthInsurance,
  }) async {
    try {
      await FirebaseFirestoreUtil.update(
        table: table,
        id: userId,
        data: {
          'healthInsurance': healthInsurance,
          'updatedDate': Timestamp.now(),
        },
      );
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, _lang);
    }
  }

  @override
  Future<void> updateUserLanguages({
    required String userId,
    required List<String> languages,
  }) async {
    try {
      await FirebaseFirestoreUtil.update(
        table: table,
        id: userId,
        data: {
          'languages': languages,
          'updatedDate': Timestamp.now(),
        },
      );
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, _lang);
    }
  }

  @override
  Future<void> updateUserTimeZone({
    required String userId,
    required String timeZone,
  }) async {
    try {
      await FirebaseFirestoreUtil.update(
        table: table,
        id: userId,
        data: {
          'timeZone': timeZone,
          'updatedDate': Timestamp.now(),
        },
      );
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, _lang);
    }
  }

  @override
  Future<void> updateCityOfOperation({
    required String userId,
    required String local,
    required double latitude,
    required double longitude,
  }) async {
    try {
      await FirebaseFirestoreUtil.update(
        table: table,
        id: userId,
        data: {
          'local': local,
          'latitude': latitude,
          'longitude': longitude,
          'updatedDate': Timestamp.now(),
        },
      );
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, _lang);
    }
  }

  @override
  Future<void> updateUserAboutMe({
    required String userId,
    required String aboutMe,
  }) async {
    try {
      await FirebaseFirestoreUtil.update(
        table: table,
        id: userId,
        data: {
          'aboutMe': aboutMe,
          'updatedDate': Timestamp.now(),
        },
      );
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, _lang);
    }
  }

  @override
  Future<void> updateUserTrainings({
    required String userId,
    required List<String> trainings,
  }) async {
    try {
      await FirebaseFirestoreUtil.update(
        table: table,
        id: userId,
        data: {
          'trainings': trainings,
          'updatedDate': Timestamp.now(),
        },
      );
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, _lang);
    }
  }

  @override
  Future<void> updateUserAddresses({
    required AddressData address,
  }) async {
    try {
      await FirebaseFirestoreUtil.update(
        table: tableAddresses,
        id: address.id,
        data: {
          ...address.toMap,
          'updatedDate': Timestamp.now(),
        },
      );
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, _lang);
    }
  }

  @override
  Future<void> updateUserGalery({
    required String userId,
    required List<String> galery,
  }) async {
    try {
      await FirebaseFirestoreUtil.update(
        table: table,
        id: userId,
        data: {
          'galery': galery,
          'updatedDate': Timestamp.now(),
        },
      );
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, _lang);
    }
  }

  @override
  Future<void> updateUserCommonQuestion({
    required String userId,
    required List<CommonQuestion> commonQuestions,
  }) async {
    try {
      await FirebaseFirestoreUtil.update(
        table: table,
        id: userId,
        data: {
          'commonQuestion': commonQuestions.map((e) => e.toMap).toList(),
          'updatedDate': Timestamp.now(),
        },
      );
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, _lang);
    }
  }

  @override
  Future<void> toogleUserState({
    required String userId,
    required UserState userState,
    required UserType userType,
  }) async {
    try {
      _permitedEdit(userId: userId, userType: userType);

      await FirebaseFirestoreUtil.update(
        table: table,
        id: userId,
        data: {
          'userState': userState.index,
          'updatedDate': Timestamp.now(),
        },
      );
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, _lang);
    }
  }

  @override
  Future<void> updateLocale({
    required String userId,
    required Locale locale,
  }) async {
    try {
      final localeName = "${locale.languageCode}_${locale.countryCode}";
      await FirebaseFirestoreUtil.update(
        table: table,
        id: userId,
        data: {
          'localeName': localeName.toLowerCase(),
        },
      );
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, _lang);
    }
  }

  void _permitedEdit({
    required String userId,
    required UserType userType,
  }) {
    final AppUser? appUser = AuthService().currentUser;
    if (appUser == null) return;
    if (!appUser.userPermited(UserType.approved) ||
        appUser.disabled ||
        appUser.userType.index >= userType.index ||
        appUser.id == userId) {
      throw FirestoreException("permission-denied", _lang);
    }
  }

  @override
  Future<void> updateUserType({
    required String userId,
    required UserType userType,
  }) async {
    try {
      _permitedEdit(userId: userId, userType: userType);

      await FirebaseFirestoreUtil.update(
        table: table,
        id: userId,
        data: {
          'userType': userType.index,
          'updatedDate': Timestamp.now(),
        },
      );
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, _lang);
    }
  }

  Map<String, dynamic> _toFirestore(
    AppUser user,
    SetOptions? options, [
    register = false,
  ]) {
    final map = {
      'name': user.name,
      'email': user.email,
      'phones': user.phones.map((val) => val.toMap).toList(),
      'isHealthInsurance': user.isHealthInsurance,
      'profession': user.profession,
      'specialty': user.specialty,
      'registerNumber': user.registerNumber,
      'registerClassOrder': user.registerClassOrder,
      'pix': user.pix,
      'services': user.services.map((e) => e.toMap).toList(),
      'experiences': user.experiences,
      'diseasesTreated': user.diseasesTreated,
      'healthInsurance': user.healthInsurance,
      'languages': user.languages,
      'trainings': user.trainings,
      'aboutMe': user.aboutMe,
      'galery': user.galery,
      'commonQuestion': user.commonQuestion.map((e) => e.toMap).toList(),
      'links': user.links.toMap,
      'firebaseMessagingToken': user.firebaseMessagingToken,
      'freeTrialEducationExpirationDate': user.freeTrialEducationExpirationDate,
      'deviceType': user.deviceType,
      'imageUrl': user.imageUrl,
      'userState': user.userState.index,
      'userType': user.userType.index,
      'shopping': user.shopping.map((e) => e.toMap).toList(),
      "localeName": user.localeName.toLowerCase(),
      "timeZone": user.timeZone,
      "freeTrialExpirationDate": user.freeTrialExpirationDate != null
          ? Timestamp.fromDate(user.freeTrialExpirationDate!)
          : null,
      'updatedDate': Timestamp.fromDate(user.updatedDate),
      "norms": Timestamp.fromDate(user.norms),
      "terms": Timestamp.fromDate(user.terms),
    };

    if (register) {
      map.putIfAbsent("subscriptionData", () => null);
      map.putIfAbsent("createdDate", () => Timestamp.now());
    }

    return map;
  }

  static AppUser _fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    Map<String, dynamic> data = doc.data()!;
    List<UserService> services = data['services']
        .map(
          (val) => UserService(
            service: val["service"],
            price: val["price"]?.toString(),
            priceFixed: val["priceFixed"] ?? true,
          ),
        )
        .toList()
        .cast<UserService>();
    services
        .add(const UserService(price: null, service: "", priceFixed: false));

    List<CommonQuestion> commonQuestion = data['commonQuestion']
        .map(
          (val) => CommonQuestion(
            question: val["question"],
            response: val["response"],
          ),
        )
        .toList()
        .cast<CommonQuestion>();

    final List<Shopping> shopping = data['shopping']
            ?.map(
              (val) => Shopping(
                id: val["id"],
                name: val["name"],
              ),
            )
            .toList()
            .cast<Shopping>() ??
        [];

    final List<Phone> phones = data['phones']
            ?.map(
              (val) => Phone(
                number: val["number"] ?? "",
                verified: val["verified"] ?? false,
              ),
            )
            .toList()
            .cast<Phone>() ??
        [];
    return AppUser(
      id: doc.id,
      name: data['name'],
      email: data['email'],
      phones: phones,
      userVerified: data['userVerified'] ?? false,
      addresses: [
        AddressData(
          id: "id",
          userId: doc.id,
          street: null,
          number: null,
          complement: null,
          zipCode: null,
          neighborhood: null,
          local: "",
          lat: 0,
          lng: 0,
          coordinates: null,
        )
      ],
      isHealthInsurance: data['isHealthInsurance'] ?? false,
      subscriptionData: null,
      shopping: shopping,
      profession: data['profession']?.cast<String>() ?? [],
      specialty: data['specialty']?.cast<String>() ?? [],
      registerNumber: data['registerNumber'],
      registerClassOrder: data['registerClassOrder'],
      pix: data['pix'],
      services: services,
      experiences: data['experiences'].cast<String>(),
      diseasesTreated: data['diseasesTreated']?.cast<String>() ?? [],
      healthInsurance: data['healthInsurance']?.cast<String>() ?? [],
      languages: data['languages'].cast<String>(),
      trainings: data['trainings'].cast<String>(),
      commonQuestion: commonQuestion,
      galery: data['galery'].cast<String>(),
      aboutMe: data['aboutMe'],
      links: Links(
        facebook: data['links']['facebook'],
        site: data['links']['site'],
        instagram: data['links']['instagram'],
        twitter: data['links']['twitter'],
      ),
      freeTrialExpirationDate: data['freeTrialExpirationDate']?.toDate(),
      freeTrialEducationExpirationDate:
          data['freeTrialEducationExpirationDate']?.toDate(),
      localeName: data['localeName'] ?? "",
      timeZone: data['timeZone'] ?? "",
      firebaseMessagingToken: data['firebaseMessagingToken'],
      deviceType: data['deviceType'],
      imageUrl: data['imageUrl'] ?? 'assets/images/avatar.png',
      userState: UserState.values[data['userState']],
      userType: UserType.values[data['userType']],
      updatedDate: data['updatedDate'].toDate(),
      createdDate: data['createdDate'].toDate(),
      terms: data['terms'].toDate(),
      norms: data['norms'].toDate(),
    );
  }

  static WebUser _fromFirestoreWebUser(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    Map<String, dynamic> data = doc.data()!;

    return WebUser(
      id: doc.id,
      name: data['name'],
      email: data['email'],
      phone: data['phone'],
      local: data['local'] ?? "",
      coordinates: Coordinates(
        lat:
            double.tryParse(data['coordinates']?["lat"]?.toString() ?? "0.0") ??
                0.0,
        lng:
            double.tryParse(data['coordinates']?["lng"]?.toString() ?? "0.0") ??
                0.0,
      ),
      isFromApp: data['isFromApp'] ?? false,
      firebaseMessagingToken: data['firebaseMessagingToken'],
      photoUrl: data['photoUrl'] ?? 'assets/images/avatar.png',
      createdDate: data['createdDate'].toDate(),
      terms: data['terms'].toDate(),
    );
  }

  Map<String, dynamic> _toFirestoreWebUser(
    WebUser user,
    SetOptions? options, [
    register = false,
  ]) {
    final map = {
      'name': user.name,
      'email': user.email,
      'phone': user.phone,
      "local": user.local,
      'coordinates': user.coordinates.toMap,
      'firebaseMessagingToken': user.firebaseMessagingToken,
      'photoUrl': user.photoUrl,
      'isFromApp': user.isFromApp,
      "terms": Timestamp.fromDate(user.terms),
    };

    if (register) {
      map.putIfAbsent("subscriptions", () => null);
      map.putIfAbsent("createdDate", () => Timestamp.now());
    }

    return map;
  }

  static AddressData _fromFirestoreAddress(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    Map<String, dynamic> data = doc.data()!;

    final bool existCoordinates = data["coordinates"] != null;

    final Coordinates? coordinates = existCoordinates
        ? Coordinates(
            lat: data["coordinates"]?["lat"] ?? 0,
            lng: data["coordinates"]?["lng"] ?? 0,
          )
        : null;
    return AddressData(
      id: doc.id,
      userId: data["userId"],
      street: data["street"],
      number: data["number"],
      complement: data["complement"],
      zipCode: data["zipCode"],
      neighborhood: data["neighborhood"] != null
          ? FormaterUtil.capitalize(data["neighborhood"] ?? "")
          : null,
      lat: double.parse(data["lat"].toString()),
      lng: double.parse(data["lng"].toString()),
      coordinates: coordinates,
      local: data["local"] ?? "",
    );
  }

  Map<String, dynamic> _toFirestoreAddress(
    AddressData address,
    SetOptions? options,
  ) {
    final map = address.toMap;

    return map;
  }
}

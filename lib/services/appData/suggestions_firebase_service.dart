import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorfriend/models/app_contact.dart';
import 'package:doctorfriend/models/app_data.dart';
import 'package:doctorfriend/models/common_question.dart';
import 'package:doctorfriend/models/fields_of_practice.dart';
import 'package:doctorfriend/models/links.dart';
import 'package:doctorfriend/models/profession.dart';
import 'package:doctorfriend/services/appData/suggestions_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/utils/firebase/firebase_firestore_util.dart';
import 'package:doctorfriend/utils/firebase/firebase_tables_util.dart';

final String professionsTable = FirebaseTablesUtil.professions;
final String specialtiesTable = FirebaseTablesUtil.specialties;
final store = FirebaseFirestoreUtil.store;

class AppDataFirebaseService implements AppDataService {
  final String _lang = Translations.currentLocale.languageCode;
  @override
  Future<List<Profession>> getProfessions() async {
    final professionsData = await _getProfessionsByTable(professionsTable);

    final professionsList =
        professionsData.docs.map((doc) => doc.data()).toList();

    final specialtiesData = await _getSpecialtiesByTable(specialtiesTable);
    final specialtiesDataList =
        specialtiesData.docs.map((doc) => doc.data()).toList();
    for (final profession in professionsList) {
      final list = [...specialtiesDataList];
      list.removeWhere((val) => val.professionId != profession.id);
      list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      profession.specialties.addAll([...list]);
    }

    professionsList
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return professionsList;
  }

  Future<QuerySnapshot<Profession>> _getProfessionsByTable(String table) async {
    return await store
        .collection(table)
        .withConverter(
          fromFirestore: _fromFirestoreProfessions,
          toFirestore: _toFirestoreProfessions,
        )
        .get();
  }

  Future<QuerySnapshot<Specialties>> _getSpecialtiesByTable(
      String table) async {
    return await store
        .collection(table)
        .withConverter(
          fromFirestore: _fromFirestoreSpecialties,
          toFirestore: _toFirestoreSpecialties,
        )
        .get();
  }

  @override
  Future<AppData?> getAppData() async {
    final doc = await store.collection("appData").doc("app_data").get();
    if (!doc.exists) return null;
    final appData = doc.data();
    if (appData == null) return null;

    final constDoc =
        await store.collection("appData").doc("app_data_const").get();
    if (!constDoc.exists) return null;
    final constData = constDoc.data();
    if (constData == null) return null;

    List<CommonQuestion> commonQuestion = appData['commonQuestions']?[_lang]
            .map(
              (vale) => CommonQuestion(
                question: vale["question"] ?? "",
                response: vale["response"] ?? "",
              ),
            )
            .toList()
            .cast<CommonQuestion>() ??
        [];

    return AppData(
      appContact: AppContact(
        phone: constData['contact']?['phone'],
        phoneSuport: constData['contact']?['phoneSuport'],
        email: constData['contact']?['email'],
        franchiseeNumber: constData['contact']?['franchiseeNumber'],
      ),
      commonQuestion: commonQuestion,
      manual: appData['manual']?[_lang] ?? "",
      termsURL: constData['termsURL'] ?? "",
      showSubscritions: constData['showSubscritions'],
      privacyPolicyURL: constData['privacyPolicyURL'] ?? "",
      telemedicineWorn: appData['telemedicineWorn']?[_lang] ?? "",
      franchiseeText: appData['franchiseeText']?[_lang] ?? "",
      site: constData['site'] ?? "",
      links: const Links(
          site: null, facebook: null, instagram: null, twitter: null),
    );
  }

  // Product => Map<String, dynamic>
  Map<String, dynamic> _toFirestoreProfessions(
    Profession profession,
    SetOptions? options, [
    register = false,
  ]) {
    final map = {
      'classOrder': profession.classOrder,
      "name_$_lang": profession.name,
      "specialties": profession.specialties,
      "isMedic": profession.isMedic,
    };

    return map;
  }

  // Map<String, dynamic> => Product
  Profession _fromFirestoreProfessions(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    Map<String, dynamic> data = doc.data()!;
    return Profession(
      id: doc.id,
      classOrder: data["classOrder"] ?? "",
      name: data["name_$_lang"] ?? "",
      isMedic: data["isMedic"] ?? false,
      specialties: [],
    );
  }

  // Product => Map<String, dynamic>
  Map<String, dynamic> _toFirestoreSpecialties(
    Specialties specialties,
    SetOptions? options, [
    register = false,
  ]) {
    final map = {
      'professionId': specialties.professionId,
      "name_$_lang": specialties.name,
    };

    return map;
  }

  // Map<String, dynamic> => Product
  Specialties _fromFirestoreSpecialties(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    Map<String, dynamic> data = doc.data()!;
    return Specialties(
      id: doc.id,
      professionId: data["professionId"] ?? "",
      name: data["name_$_lang"] ?? "",
    );
  }
}

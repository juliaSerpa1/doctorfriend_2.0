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
final String fieldsOfPracticeTable = FirebaseTablesUtil.fieldsOfPractice;
final store = FirebaseFirestoreUtil.store;

class AppDataFirebaseService implements AppDataService {
  final String _lang = Translations.currentLocale.languageCode;
  @override
  Future<List<Profession>> getProfessions() async {
    final professionsData = await _getProfessionsByTable(professionsTable);

    final professionsList =
        professionsData.docs.map((doc) => doc.data()).toList();

    final fieldsOfPracticeData =
        await _getFieldsOfPracticeByTable(fieldsOfPracticeTable);
    final fieldsOfPracticeDataList =
        fieldsOfPracticeData.docs.map((doc) => doc.data()).toList();
    for (final profession in professionsList) {
      final list = [...fieldsOfPracticeDataList];
      list.removeWhere((val) => val.professionId != profession.id);
      list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      profession.fieldsOfPractice.addAll([...list]);
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

  Future<QuerySnapshot<FieldsOfPractice>> _getFieldsOfPracticeByTable(
      String table) async {
    return await store
        .collection(table)
        .withConverter(
          fromFirestore: _fromFirestoreFieldsOfPractice,
          toFirestore: _toFirestoreFieldsOfPractice,
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
      "fieldsOfPractice": profession.fieldsOfPractice,
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
      fieldsOfPractice: [],
    );
  }

  // Product => Map<String, dynamic>
  Map<String, dynamic> _toFirestoreFieldsOfPractice(
    FieldsOfPractice fieldsOfPractice,
    SetOptions? options, [
    register = false,
  ]) {
    final map = {
      'professionId': fieldsOfPractice.professionId,
      "name_$_lang": fieldsOfPractice.name,
    };

    return map;
  }

  // Map<String, dynamic> => Product
  FieldsOfPractice _fromFirestoreFieldsOfPractice(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    Map<String, dynamic> data = doc.data()!;
    return FieldsOfPractice(
      id: doc.id,
      professionId: data["professionId"] ?? "",
      name: data["name_$_lang"] ?? "",
    );
  }
}

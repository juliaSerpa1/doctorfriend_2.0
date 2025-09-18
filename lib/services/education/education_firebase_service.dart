import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorfriend/exeption/firestore_exception.dart';
import 'package:doctorfriend/models/course.dart';
import 'package:doctorfriend/models/profession.dart';
import 'package:doctorfriend/services/education/education_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/utils/firebase/firebase_firestore_util.dart';
import 'package:doctorfriend/utils/firebase/firebase_tables_util.dart';

class EducationFirebaseService implements EducationService {
  final String table = FirebaseTablesUtil.courses;
  final store = FirebaseFirestoreUtil.store;
  final String _lang = Translations.currentLocale.languageCode;

  @override
  Stream<List<Course>> myCourses(String userId) {
    final snapshots = store
        .collection(table)
        .where("userId", isEqualTo: userId)
        .withConverter(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        )
        .snapshots();
    return snapshots.map((snapshot) {
      final List<Course> list = [];
      for (final doc in snapshot.docs) {
        final data = doc.data();
        list.add(data);
      }
      return list;
    });
  }

  @override
  Future<List<Course>> searchCourses(String profession) async {
    final docRef = store.collection(table);

    final results = await docRef
        .where("professions", arrayContains: profession.toLowerCase())
        .withConverter(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        )
        .get();

    final list = results.docs.map((doc) => doc.data()).toList();
    return list;
  }

  @override
  Future<Course?> getCourseById(String id) async {
    final docRef = store.collection(table).doc(id);

    final results = await docRef
        .withConverter(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        )
        .get();

    return results.data();
  }

  @override
  Future<void> addCourse(Course course) async {
    try {
      final docRef = store.collection(table);

      await docRef.add(_toFirestore(course, null, true));
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, _lang);
    }
  }

  @override
  Future<void> deleteCourse(String courseId) async {
    try {
      final docRef = store.collection(table).doc(courseId);

      await docRef.delete();
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, _lang);
    }
  }

  @override
  Future<void> updateCourse(Course course) async {
    try {
      final uid = course.id;
      final docRef = store.collection(table).doc(uid);

      return await docRef.update(_toFirestore(course, null, true));
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, _lang);
    }
  }

  Map<String, dynamic> _toFirestore(
    Course course,
    SetOptions? options, [
    register = false,
  ]) {
    final map = {
      "userId": course.userId,
      "title": course.title,
      "descriptio": course.descriptio,
      "thumbnail": course.thumbnail,
      "professions": course.professions.map((e) => e.id).toList(),
      "link": course.link,
      "notifyAll": course.notifyAll,
    };

    return map;
  }

  static Course _fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    Map<String, dynamic> data = doc.data()!;

    return Course(
      id: doc.id,
      userId: data['userId'],
      title: data['title'],
      descriptio: data['descriptio'],
      thumbnail: data['thumbnail'],
      professions: data['professions']
          .map(
            (val) => Profession(
              id: val as String,
              name: "",
              isMedic: false,
              classOrder: "",
              specialties: [],
            ),
          )
          .toList()
          .cast<Profession>(),
      link: data['link'],
      notifyAll: data['notifyAll'] ?? true,
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreUtil {
  static final store = FirebaseFirestore.instance;

  static Future<void> add({
    required String table,
    required Map<String, dynamic> data,
  }) async {
    final docRef = store.collection(table).doc();

    return docRef.set(data);
  }

  static Future<void> update({
    required String table,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    final docRef = store.collection(table).doc(id);

    return docRef.update(data);
  }

  static Future<void> delete({
    required String table,
    required String id,
  }) async {
    final docRef = store.collection(table).doc(id);

    return docRef.delete();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorfriend/exeption/firestore_exception.dart';
import 'package:doctorfriend/models/sticky_note.dart';
import 'package:doctorfriend/services/stickyNotes/sticky_notes_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/utils/firebase/firebase_firestore_util.dart';
import 'package:doctorfriend/utils/firebase/firebase_tables_util.dart';

class StickyNotesFirebaseService implements StickyNotesService {
  final String table = FirebaseTablesUtil.stickyNotes;
  final store = FirebaseFirestoreUtil.store;
  final String _lang = Translations.currentLocale.languageCode;
  @override
  Stream<StickyNote?> stickyNote(String userId) {
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
  Future<void> addStickyNote(StickyNote stickyNote) async {
    try {
      final uid = stickyNote.userId;
      final docRef = store.collection(table).doc(uid);

      return await docRef.set(_toFirestore(stickyNote, null, true));
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, _lang);
    }
  }

  Map<String, dynamic> _toFirestore(
    StickyNote user,
    SetOptions? options, [
    register = false,
  ]) {
    final map = {
      'stickyNotes': user.stickyNotes,
    };

    return map;
  }

  static StickyNote _fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    Map<String, dynamic> data = doc.data()!;

    return StickyNote(
      userId: doc.id,
      stickyNotes: data['stickyNotes'].cast<String>(),
    );
  }
}

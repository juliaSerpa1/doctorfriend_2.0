import 'package:doctorfriend/models/sticky_note.dart';
import 'package:doctorfriend/services/stickyNotes/sticky_notes_firebase_service.dart';

abstract class StickyNotesService {
  Stream<StickyNote?> stickyNote(String userId);

  Future<void> addStickyNote(StickyNote user);

  factory StickyNotesService() {
    return StickyNotesFirebaseService();
  }
}

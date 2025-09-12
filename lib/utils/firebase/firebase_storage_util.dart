import 'dart:io';
import 'package:doctorfriend/exeption/handle_exception.dart';
import 'package:doctorfriend/models/upload_stream.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class FirebaseStorageUtil {
  static final FirebaseStorage storage = FirebaseStorage.instance;

  static Future<UploadStream> uploadFile({
    required String table,
    required File file,
    required String fileName,
  }) async {
    String extens = extension(file.path).substring(1);
    final name = '$fileName.$extens';
    final imageRef = storage.ref().child(table).child(name);
    getDownloadURL() async => await imageRef.getDownloadURL();
    final String contentType = "image/$extens";
    return UploadStream(
      snapshotEvents: imageRef
          .putFile(file, SettableMetadata(contentType: contentType))
          .snapshotEvents,
      getDownloadURL: getDownloadURL,
    );
  }

  static Future<String> uploadFileSimple({
    required String table,
    required File file,
    required String fileName,
  }) async {
    String extens = extension(file.path).substring(1);
    final name = '$fileName.$extens';
    final imageRef = storage.ref().child(table).child(name);
    final String contentType = "image/$extens";
    await imageRef.putFile(
      file,
      SettableMetadata(contentType: contentType),
    );
    return await imageRef.getDownloadURL();
  }

  static Future<void> deleteFile({
    required String table,
    required String url,
    required String lang,
  }) async {
    try {
      final imageRef = storage.refFromURL(url);
      return await imageRef.delete();
    } catch (error) {
      throw HandleException("Error Ao deletar arquivo", lang);
    }
  }
}

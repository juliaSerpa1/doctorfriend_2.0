import 'package:cloud_firestore/cloud_firestore.dart';

class Verification {
  final String id;
  final String documentText;
  final String documentUrl;
  final String selfieUrl;

  const Verification({
    required this.id,
    required this.documentText,
    required this.documentUrl,
    required this.selfieUrl,
  });

  Map<String, dynamic> get toMap {
    return {
      "documentText": documentText,
      "documentUrl": documentUrl,
      "selfieUrl": selfieUrl,
      "updateAt": Timestamp.now(),
    };
  }
}

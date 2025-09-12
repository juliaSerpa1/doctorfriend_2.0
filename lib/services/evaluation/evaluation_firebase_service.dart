import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorfriend/exeption/firestore_exception.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/models/evaluation.dart';
import 'package:doctorfriend/models/evaluations_numbers.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:doctorfriend/services/evaluation/evaluation_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/utils/firebase/firebase_firestore_util.dart';
import 'package:doctorfriend/utils/firebase/firebase_tables_util.dart';

final String table = FirebaseTablesUtil.evaluations;
final store = FirebaseFirestoreUtil.store;

class EvaluationFirebaseService implements EvaluationService {
  final AppUser user = AuthService().currentUser!;
  final String _lang = Translations.currentLocale.languageCode;
  @override
  Stream<List<Evaluation>> evaluations() {
    final snapshots = store
        .collection(table)
        .withConverter(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        )
        .where("userId", isEqualTo: user.id)
        .orderBy('createdDate')
        .snapshots();

    return snapshots.map((snapshot) {
      return snapshot.docs
          .map((doc) {
            return doc.data();
          })
          .toList()
          .reversed
          .toList();
    });
  }

  @override
  Future<EvaluationNumbers> getRateMedium() async {
    final snapshots = store
        .collection(table)
        .withConverter(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        )
        .where("userId", isEqualTo: user.id);

    final doc = await snapshots.get();

    List<Evaluation> data = doc.docs.map((e) => e.data()).toList();
    return EvaluationNumbers(
      avarage: _calcularMedia(data),
      amount: data.length,
    );
  }

  double _calcularMedia(List<Evaluation> evaluations) {
    if (evaluations.isEmpty) {
      return 0.0; // Retorna 0 se a lista estiver vazia para evitar divisão por zero
    }

    // Soma todos os números na lista
    double soma =
        evaluations.map((val) => val.rate.toDouble()).reduce((a, b) => a + b);

    // Calcula a média dividindo a soma pelo número de elementos
    double media = soma / evaluations.length;

    return media;
  }

  @override
  Future<void> toggleShow({
    required String evaluationId,
    required bool show,
  }) async {
    try {
      await FirebaseFirestoreUtil.update(
        table: table,
        id: evaluationId,
        data: {
          'show': show,
        },
      );
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, _lang);
    }
  }

  @override
  Future<void> responseEvaluation({
    required String evaluationId,
    required String responseText,
  }) async {
    try {
      await FirebaseFirestoreUtil.update(
        table: table,
        id: evaluationId,
        data: {
          'responseText': responseText.trim() == "" ? null : responseText,
          'responseDate': Timestamp.now(),
        },
      );
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, _lang);
    }
  }

  Map<String, dynamic> _toFirestore(
    Evaluation responseText,
    SetOptions? options, [
    register = false,
  ]) {
    final map = {
      'userId': responseText.userId,
      'customerId': responseText.customerId,
      'customerName': responseText.customerName,
      'text': responseText.text,
      'responseText': responseText.responseText,
      'rate': responseText.rate,
      'show': responseText.show,
      'createdDate': Timestamp.fromDate(responseText.createdDate),
      'responseDate': responseText.responseDate != null
          ? Timestamp.fromDate(responseText.responseDate!)
          : null,
    };

    return map;
  }

  static Evaluation _fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    Map<String, dynamic> data = doc.data()!;

    return Evaluation(
      id: doc.id,
      userId: data['userId'],
      customerId: data['customerId'],
      customerName: data['customerName'],
      text: data['text'],
      responseText: data['responseText'],
      rate: data['rate'],
      show: data['show'],
      createdDate: data['createdDate'].toDate(),
      responseDate: data['responseDate']?.toDate(),
    );
  }
}

import 'package:doctorfriend/models/evaluation.dart';
import 'package:doctorfriend/models/evaluations_numbers.dart';
import 'package:doctorfriend/services/evaluation/evaluation_firebase_service.dart';

abstract class EvaluationService {
  Stream<List<Evaluation>> evaluations();
  Future<EvaluationNumbers> getRateMedium();

  Future<void> toggleShow({required String evaluationId, required bool show});
  Future<void> responseEvaluation({
    required String evaluationId,
    required String responseText,
  });

  factory EvaluationService() {
    return EvaluationFirebaseService();
  }
}

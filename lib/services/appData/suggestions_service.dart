import 'package:doctorfriend/models/app_data.dart';
import 'package:doctorfriend/models/profession.dart';
import 'package:doctorfriend/services/appData/suggestions_firebase_service.dart';

abstract class AppDataService {
  Future<List<Profession>> getProfessions();
  Future<AppData?> getAppData();

  factory AppDataService() {
    return AppDataFirebaseService();
  }
}

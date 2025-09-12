import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/models/schedule_time_of_day.dart';
import 'package:doctorfriend/services/email/email_firebase_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';

abstract class EmailService {
  Future<Stream<Map<String, dynamic>?>> sendRemaiderEmail({
    required ScheduletimeOfDay scheduletimeOfDay,
    required AppUser user,
    required Translations traslationContext,
  });

  factory EmailService() {
    return EmailFirebaseService();
  }
}

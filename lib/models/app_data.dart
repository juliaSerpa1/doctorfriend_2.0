import 'package:doctorfriend/models/app_contact.dart';
import 'package:doctorfriend/models/common_question.dart';
import 'package:doctorfriend/models/links.dart';

class AppData {
  final AppContact appContact;
  final List<CommonQuestion> commonQuestion;
  final String manual;
  final Links links;
  final String privacyPolicyURL;
  final String termsURL;
  final String site;
  final String telemedicineWorn;
  final String franchiseeText;
  final bool? showSubscritions;

  const AppData({
    required this.appContact,
    required this.commonQuestion,
    required this.manual,
    required this.links,
    required this.termsURL,
    required this.privacyPolicyURL,
    required this.site,
    required this.telemedicineWorn,
    required this.franchiseeText,
    required this.showSubscritions,
  });
}

import 'package:doctorfriend/models/profession.dart';

class Course {
  final String id;
  final String userId;
  final String title;
  final String descriptio;
  final String thumbnail;
  final List<Profession> professions;
  final String link;
  final bool notifyAll;

  const Course({
    required this.id,
    required this.userId,
    required this.title,
    required this.descriptio,
    required this.thumbnail,
    required this.professions,
    required this.link,
    required this.notifyAll,
  });
}

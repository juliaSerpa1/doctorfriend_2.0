import 'package:doctorfriend/models/fields_of_practice.dart';

class Profession {
  final String id;
  final String classOrder;
  final String name;
  final List<FieldsOfPractice> fieldsOfPractice;
  final bool isMedic;

  const Profession({
    required this.id,
    required this.classOrder,
    required this.name,
    required this.fieldsOfPractice,
    required this.isMedic,
  });
}

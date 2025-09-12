import 'package:doctorfriend/models/coordinates.dart';

class WebUser {
  final String id;
  final String name;
  final String email;
  final String? phone;

  final String? local; //endereço para pesquisa no site
  final Coordinates coordinates;

  final String? firebaseMessagingToken;
  final String? photoUrl;

  final DateTime createdDate;
  final DateTime terms;
  final bool isFromApp;

  const WebUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.local,
    required this.coordinates,
    required this.firebaseMessagingToken,
    required this.createdDate,
    required this.photoUrl,
    required this.terms,
    required this.isFromApp,
  });
}

import 'package:doctorfriend/exeption/traslations/ar.dart';
import 'package:doctorfriend/exeption/traslations/bn.dart';
import 'package:doctorfriend/exeption/traslations/da.dart';
import 'package:doctorfriend/exeption/traslations/de.dart';
import 'package:doctorfriend/exeption/traslations/en.dart';
import 'package:doctorfriend/exeption/traslations/es.dart';
import 'package:doctorfriend/exeption/traslations/fi.dart';
import 'package:doctorfriend/exeption/traslations/fr.dart';
import 'package:doctorfriend/exeption/traslations/hi.dart';
import 'package:doctorfriend/exeption/traslations/id.dart';
import 'package:doctorfriend/exeption/traslations/it.dart';
import 'package:doctorfriend/exeption/traslations/ja.dart';
import 'package:doctorfriend/exeption/traslations/nb.dart';
import 'package:doctorfriend/exeption/traslations/nl.dart';
import 'package:doctorfriend/exeption/traslations/pt.dart';
import 'package:doctorfriend/exeption/traslations/ru.dart';
import 'package:doctorfriend/exeption/traslations/sv.dart';
import 'package:doctorfriend/exeption/traslations/sw.dart';
import 'package:doctorfriend/exeption/traslations/tr.dart';

class FirestoreException implements Exception {
  final String _code;
  final String _language; // Adicionado para armazenar a escolha do idioma

  const FirestoreException(this._code, this._language);

  String get message {
    // Mapeamento das mensagens de erro para português e inglês
    const errorMessages = {
      'pt': firestorePT, // Português ☑️
      'en': firestoreEN, // Inglês ☑️
      'es': firestoreES, // Espanhol ☑️
      'fr': firestoreFR, // Francês ☑️
      'ar': firestoreAR, // Árabe ☑️
      'de': firestoreDE, // Alemão ☑️
      'ru': firestoreRU, // Russo ☑️
      'ja': firestoreJA, // Japonês ☑️
      'hi': firestoreHI, // Hindi ☑️
      'bn': firestoreBN, // Bengali
      'da': firestoreDA, // Dinamarquês
      'fi': firestoreFI, // Finlandês
      'id': firestoreID, // Indonésio
      'it': firestoreIT, // Italiano
      'nb': firestoreNB, // Norueguês
      'nl': firestoreNL, // Holandês
      'sv': firestoreSV, // Sueco
      'sw': firestoreSW, // Suaíli
      'tr': firestoreTR, // Turco
    };

    // Obter a mensagem correspondente ao código de erro e idioma selecionado
    return errorMessages[_language]?[_code] ??
        errorMessages[_language]?['unexpected-error'] ??
        'Erro inesperado';
  }
}

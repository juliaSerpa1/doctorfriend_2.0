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

class HandleException implements Exception {
  final String _code;
  final String _language; // Adicionado para armazenar a escolha do idioma
  final String _complement;
  const HandleException(this._code, this._language, [this._complement = ""]);

  String get message {
    // Mapeamento das mensagens de erro para português e inglês
    final errorMessages = {
      'pt': exceptionPT(_complement), // Português ☑️
      'en': exceptionEN(_complement), // Inglês ☑️
      'es': exceptionES(_complement), // Espanhol ☑️
      'fr': exceptionFR(_complement), // Francês ☑️
      'ar': exceptionAR(_complement), // Árabe ☑️
      'de': exceptionDE(_complement), // Alemão ☑️
      'ru': exceptionRU(_complement), // Russo ☑️
      'ja': exceptionJA(_complement), // Japonês ☑️
      'hi': exceptionHI(_complement), // Hindi ☑️
      'bn': exceptionBN(_complement), // Bengali
      'da': exceptionDA(_complement), // Dinamarquês
      'fi': exceptionFI(_complement), // Finlandês
      'id': exceptionID(_complement), // Indonésio
      'it': exceptionIT(_complement), // Italiano
      'nb': exceptionNB(_complement), // Norueguês
      'nl': exceptionNL(_complement), // Holandês
      'sv': exceptionSV(_complement), // Sueco
      'sw': exceptionSW(_complement), // Suaíli
      'tr': exceptionTR(_complement), // Turco
    };

    // Retornar a mensagem completa
    return errorMessages[_language]?[_code] ??
        errorMessages[_language]?['unexpected-error'] ??
        'Erro inesperado';
  }
}

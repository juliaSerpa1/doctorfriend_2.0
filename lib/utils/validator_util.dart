import 'package:doctorfriend/services/traslation/traslation.dart';

class ValidatorUtil {
  static String? validateEmail(String value) {
    if (value.isEmpty) {
      return null;
    }

    // Expressão regular para verificar o formato do email
    String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    if (!RegExp(emailRegex).hasMatch(value.trim())) {
      final traslation = Translations.traslation?['validators'];
      return traslation?["invalidEmail"];
    }

    return null;
  }

  static String? validatePassoword(String value) {
    if (value.isEmpty) {
      return null;
    }
    if (value.length < 6) {
      final traslation = Translations.traslation?['validators'];
      return traslation?["invalidPass"];
    }

    return null;
  }

  static String? validateConfirmPassword(String pass1, String pass2) {
    if (pass1 != pass2) {
      final traslation = Translations.traslation?['validators'];
      return traslation?["invalidConfirmPass"];
    }

    return null;
  }

  static String? validateCEP(String value) {
    if (value.isEmpty) {
      return null;
    }
    // // Expressão regular para verificar o formato do CEP
    // String cepRegex = r'^\d{5}-\d{3}$';
    // if (!RegExp(cepRegex).hasMatch(value)) {
    //   return 'Por favor, insira um CEP válido.';
    // }

    if (value.length < 8) {
      final traslation = Translations.traslation?['validators'];
      return traslation?["invalidZipCode"];
    }

    return null;
  }

  static String? validateUrl(String value, [empty = true]) {
    if (value.isEmpty) {
      return empty ? null : "";
    }
    // Expressão regular para validar a URL
    const urlPattern =
        r'^(https?:\/\/)?([a-zA-Z0-9.-]+)(\.[a-zA-Z]{2,})(:[0-9]{1,5})?(\/.*)?$';
    final regex = RegExp(urlPattern);

    if (!regex.hasMatch(value)) {
      final traslation = Translations.traslation?['validators'];
      return traslation?["invalidUrl"];
    }
    return null;
  }
}

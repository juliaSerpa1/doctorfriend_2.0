import 'package:doctorfriend/services/traslation/locale_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

//final remoteConfig = FirebaseRemoteConfig.instance;
const supportedLocales = [
  "pt", // Português ☑️
  "en", // Inglês ☑️
  "es", // Espanhol ☑️
  "fr", // Francês ☑️
  "ar", // Árabe ☑️
  "de", // Alemão ☑️
  "ru", // Russo ☑️
  "ja", // Japonês ☑️
  "hi", // Hindi ☑️
  "bn", // Bengali
  "da", // Dinamarquês
  "fi", // Finlandês
  "id", // Indonésio
  "it", // Italiano
  "nb", // Norueguês
  "nl", // Holandês
  "sv", // Sueco
  "sw", // Suaíli
  "tr", // Turco ☑️
]; //20 no total

// "ga", // Irlandês
class Translations {
  final Locale locale;
  static List<LocaleName> localesAvaliable = [
    const LocaleName(
      name: "Português",
      locale: Locale('pt', "BR"), // Português - Brasil
    ),
    const LocaleName(
      name: "English",
      locale: Locale('en', "US"), // Inglês - Estados Unidos
    ),
    const LocaleName(
      name: "Español",
      locale: Locale('es', 'ES'), // Espanhol - Espanha
    ),
    const LocaleName(
      name: "Français",
      locale: Locale('fr', 'FR'), // Francês - França
    ),
    const LocaleName(
      name: "عربي",
      locale: Locale('ar', 'SA'), // Árabe - Arábia Saudita
    ),
    const LocaleName(
      name: "Deutsch",
      locale: Locale('de', 'DE'), // Alemão - Alemanha
    ),
    const LocaleName(
      name: "Русский",
      locale: Locale('ru', 'RU'), // Russo - Rússia
    ),
    const LocaleName(
      name: "日本語",
      locale: Locale('ja', 'JP'), // Japonês - Japão
    ),
    const LocaleName(
      name: "हिन्दी",
      locale: Locale('hi', 'IN'), // Hindi - Índia
    ),
    // Idiomas adicionais
    const LocaleName(
      name: "বাংলা",
      locale: Locale('bn', 'BD'), // Bengali - Bangladesh
    ),
    const LocaleName(
      name: "Dansk",
      locale: Locale('da', 'DK'), // Dinamarquês - Dinamarca
    ),
    const LocaleName(
      name: "Suomi",
      locale: Locale('fi', 'FI'), // Finlandês - Finlândia
    ),
    const LocaleName(
      name: "Bahasa Indonesia",
      locale: Locale('id', 'ID'), // Indonésio - Indonésia
    ),
    const LocaleName(
      name: "Italiano",
      locale: Locale('it', 'IT'), // Italiano - Itália
    ),
    const LocaleName(
      name: "Norsk Bokmål",
      locale: Locale('nb', 'NO'), // Norueguês - Noruega
    ),
    const LocaleName(
      name: "Nederlands (België)",
      locale: Locale('nl', 'BE'), // Holandês - Bélgica
    ),
    const LocaleName(
      name: "Svenska",
      locale: Locale('sv', 'SE'), // Sueco - Suécia
    ),
    const LocaleName(
      name: "Kiswahili",
      locale: Locale('sw', 'SW'), // Suaíli - Quênia
    ),
    const LocaleName(
      name: "Türkçe",
      locale: Locale('tr', 'TR'), // Turco - Turquia
    ),
  ];

  static Locale _currentLocale = localesAvaliable[0].locale;
  late Map<String, Map<String, dynamic>> _localizedStrings;
  static Map<String, Map<String, dynamic>>? _traslation;

  Translations(this.locale) {
    _currentLocale = locale;
  }

  static Locale get currentLocale {
    return _currentLocale;
  }

  static Map<String, Map<String, dynamic>>? get traslation {
    return _traslation;
  }

  static Locale setLocale(Locale locale) {
    if (supportedLocales.contains(locale.languageCode)) {
      _currentLocale = locale;
    } else {
      _currentLocale = localesAvaliable[0].locale;
    }
    return _currentLocale;
  }

  Future<bool> load() async {
    String jsonString =
        await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    //await remoteConfig.setConfigSettings(RemoteConfigSettings(
    //  fetchTimeout: const Duration(minutes: 1),
    //  minimumFetchInterval: const Duration(seconds: 1),
    //));
    // await remoteConfig.setDefaults(DefaultsConfiguration.data);
    // await remoteConfig.setDefaults(jsonMap);
    // await remoteConfig.fetchAndActivate();

    _localizedStrings = jsonMap.map(
        (key, value) => MapEntry(key, (value as Map).cast<String, dynamic>()));
    _traslation = _localizedStrings;
    return true;
  }

  Map<String, dynamic> translate(String key) {
    return _localizedStrings[key] as Map<String, dynamic>;
  }

  static Translations of(BuildContext context) {
    return Localizations.of<Translations>(context, Translations)!;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<Translations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return supportedLocales.contains(locale.languageCode);
  }

  @override
  Future<Translations> load(Locale locale) async {
    Translations localizations = Translations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<Translations> old) {
    return false;
  }
}

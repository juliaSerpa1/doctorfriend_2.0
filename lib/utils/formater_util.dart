import 'package:doctorfriend/exeption/handle_exception.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/utils/tools_util.dart';
import 'package:intl/intl.dart';

class FormaterUtil {
  static double toDouble(String currencyString) {
    try {
      String cleanString = currencyString
          .replaceAll('R\$', '')
          .replaceAll(RegExp(r'[a-zA-Z]'), '')
          .replaceAll(".", "")
          .replaceAll("-", "")
          .replaceAll(',', '.')
          .trim();
      return double.parse(cleanString);
    } catch (_) {
      throw HandleException(
        "number_invalid",
        Translations.currentLocale.languageCode,
      );
    }
  }

  static String toReal(double currencyString, [bool moneySimble = true]) {
    final formatter = NumberFormat.simpleCurrency(locale: "pt_Br");
    if (!moneySimble) {
      return formatter.format(currencyString)..replaceAll('R\$', '').trim();
    }
    return formatter.format(currencyString);
  }

  static DateTime subtractMonthsFromDate(DateTime date, int months) {
    return date.subtract(
        Duration(days: months * 30)); // Aproximadamente 30 dias em um mês
  }

  static DateTime addMonthsFromDate(DateTime date, int months) {
    return date
        .add(Duration(days: months * 30)); // Aproximadamente 30 dias em um mês
  }

  static String formatDate(DateTime date, [full = false]) {
    if (full) {
      return DateFormat('dd/MM/yyyy - HH:mm').format(date);
    }
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatDateText(
      DateTime date, List<String> daysOfWeek, String today,
      [bool noText = false]) {
    String text = daysOfWeek[date.weekday - 1];
    if (ToolsUtil.isToday(date)) {
      text = today;
    }

    return "${noText ? "" : text} ${DateFormat('dd/MM').format(date)}";
  }

  static String formatDateTextFull({
    required DateTime date,
    required List<String> daysOfWeek,
    required List<String> montsOfYear,
    required String today,
  }) {
    String text = capitalize(daysOfWeek[date.weekday - 1]);
    if (ToolsUtil.isToday(date)) {
      text = today;
    }
    return "$text, ${date.day} ${capitalize(montsOfYear[date.month - 1].substring(0, 3))} ${date.year}, ${addZero(date.hour)}:${addZero(date.minute)}";
  }

  static String formatTime(DateTime date, {String format = "Hm"}) {
    return DateFormat(format).format(date);
  }

  static String capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }

  static String addZero(int number) {
    return number < 10 && number > -10 ? "0$number" : number.toString();
  }

  static String toPhoneNumber(String number) {
    return number
      ..replaceAll("(", "")
          .replaceAll(")", "")
          .replaceAll("-", "")
          .replaceAll(" ", "")
          .trim();
  }
}

import 'package:doctorfriend/components/callback.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/utils/formater_util.dart';
import 'package:url_launcher/url_launcher.dart';

class ToolsUtil {
  static bool isToday(DateTime date) {
    DateTime now = DateTime.now();
    return now.day == date.day &&
        now.month == date.month &&
        now.year == date.year;
  }

  static bool isSameDay(DateTime date, DateTime date2) {
    return date2.day == date.day &&
        date2.month == date.month &&
        date2.year == date.year;
  }

  static bool isSameMonth(DateTime date, DateTime date2) {
    return date2.month == date.month && date2.year == date.year;
  }

  static List<AppUser> filterBySearchUsers({
    required List<AppUser> users,
    required String text,
  }) {
    if (text.trim() == "" || users.isEmpty) return [...users];
    final list = [...users];
    list.removeWhere(
      (element) =>
          !element.name.toLowerCase().contains(text) &&
          !element.email.toLowerCase().contains(text) &&
          !FormaterUtil.formatDate(element.createdDate).contains(text) &&
          !element.id.toLowerCase().toString().contains(text),
    );

    return list;
  }

  static Future<void> launchURL(context, {required String urlString}) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      try {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } catch (e) {
        Callback.snackBar(
          context,
          title: 'Não foi possível abrir o link $urlString',
        );
      }
    }
  }

  static startDay() {
    final DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static String removeAccents(String input) {
    final accentsMap = {
      'á': 'a',
      'à': 'a',
      'â': 'a',
      'ã': 'a',
      'ä': 'a',
      'å': 'a',
      'Á': 'A',
      'À': 'A',
      'Â': 'A',
      'Ã': 'A',
      'Ä': 'A',
      'Å': 'A',
      'é': 'e',
      'è': 'e',
      'ê': 'e',
      'ë': 'e',
      'É': 'E',
      'È': 'E',
      'Ê': 'E',
      'Ë': 'E',
      'í': 'i',
      'ì': 'i',
      'î': 'i',
      'ï': 'i',
      'Í': 'I',
      'Ì': 'I',
      'Î': 'I',
      'Ï': 'I',
      'ó': 'o',
      'ò': 'o',
      'ô': 'o',
      'õ': 'o',
      'ö': 'o',
      'Ó': 'O',
      'Ò': 'O',
      'Ô': 'O',
      'Õ': 'O',
      'Ö': 'O',
      'ú': 'u',
      'ù': 'u',
      'û': 'u',
      'ü': 'u',
      'Ú': 'U',
      'Ù': 'U',
      'Û': 'U',
      'Ü': 'U',
      'ç': 'c',
      'Ç': 'C',
      'ñ': 'n',
      'Ñ': 'N'
    };

    return input.split('').map((char) => accentsMap[char] ?? char).join('');
  }
}

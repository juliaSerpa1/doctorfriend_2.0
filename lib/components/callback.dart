import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:flutter/material.dart';

class Callback {
  static void snackBar(
    BuildContext context, {
    String? title,
    Function()? onPress,
    String label = "",
    int seconds = 4,
    bool error = true,
    Color? color,
  }) {
    final traslation = Translations.of(context).translate('callback_default');

    if (error && title == null) {
      title = traslation["title_error"];
    } else if (!error && title == null) {
      title = traslation["title_sucess"];
    }
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
        backgroundColor: color != null
            ? color
            : error
                ? colorScheme.error
                : colorScheme.tertiaryContainer,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title!,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            if (onPress != null)
              TextButton.icon(
                onPressed: () {
                  onPress();
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                label: Text(label),
                icon: const Icon(Icons.forward_outlined),
              ),
          ],
        ),
        duration: Duration(seconds: seconds),
      ),
    );
  }

  static Future<bool> confirm({
    required BuildContext context,
    title = 'Confirmar',
    required content,
    confirmText,
    cancelText,
  }) async {
    final traslation = Translations.of(context).translate('callback_default');
    confirmText ??= traslation["confirm_text"];
    cancelText ??= traslation["cancel_text"];
    final colorScheme = Theme.of(context).colorScheme;
    final res = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              color: colorScheme.onSecondary,
              fontSize: 23,
            ),
          ),
          content: Text(
            content,
            style: TextStyle(
              color: colorScheme.onSecondary.withOpacity(.8),
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: <Widget>[
            if (cancelText != "")
              TextButton(
                child: Text(
                  cancelText,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: colorScheme.error,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false); // Fechar o AlertDialog
                },
              ),
            TextButton(
              child: Text(
                confirmText,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onPressed: () {
                // Lógica de confirmação aqui
                Navigator.of(context).pop(true); // Fechar o AlertDialog
              },
            ),
          ],
        );
      },
    );
    return res ?? false;
  }
}

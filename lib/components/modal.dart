import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:flutter/material.dart';

class Modal {
  Modal(
    BuildContext context, {
    required Widget child,
  }) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => ModalWrap(child),
    );
  }

  static Future<T?> asyncModal<T>(
    BuildContext context, {
    required Widget child,
  }) {
    return showModalBottomSheet<T>(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => ModalWrap(child),
    );
  }

  static void showLoading(BuildContext context, {required bool canPop}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LoadingScreen(canPop: canPop);
      },
    );
  }
}

class ModalWrap extends StatelessWidget {
  final Widget child;
  const ModalWrap(this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          left: 15.0,
          right: 15.0,
          top: 30.0,
        ),
        child: child,
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  final bool canPop;
  const LoadingScreen({
    super.key,
    required this.canPop,
  });

  @override
  Widget build(BuildContext context) {
    final traslation = Translations.of(context).translate('scheduled_customer');
    return PopScope(
      canPop: canPop, // Impede o retorno ao pressionar o botão de retorno
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              color:
                  Colors.black.withOpacity(0.5), // Define a opacidade do fundo
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16.0),
                Text(
                  traslation["send_email_is_proccessing"],
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

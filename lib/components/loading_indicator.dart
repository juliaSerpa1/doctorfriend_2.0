import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final bool loading;
  final bool error;
  final String? errorMessage;
  final Widget child;
  final Size size;
  const LoadingIndicator({
    super.key,
    required this.loading,
    required this.child,
    this.error = false,
    this.errorMessage,
    this.size = const Size(22, 22),
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return loading
        ? Center(
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.onSecondary,
                ),
              ),
            ),
          )
        : error
            ? Scaffold(
                body: Center(
                  child: Text(
                    errorMessage ??
                        Translations.of(context)
                            .translate('loading_error')["error_message"],
                    style: TextStyle(color: colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : child;
  }
}

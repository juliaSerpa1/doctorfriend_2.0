import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:flutter/material.dart';

class LoaderBuilder extends StatelessWidget {
  final Widget child;
  final Future<void> future;
  const LoaderBuilder({
    super.key,
    required this.child,
    required this.future,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          );
        }

        if (snapshot.hasError) {
          final traslation =
              Translations.of(context).translate('loading_error');
          return Center(
            child: Text(traslation["title"]),
          );
        }

        return child;
      },
    );
  }
}

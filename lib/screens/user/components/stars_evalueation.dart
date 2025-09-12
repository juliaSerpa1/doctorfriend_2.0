import 'package:flutter/material.dart';

class StarsEvaluetion extends StatelessWidget {
  final double media;

  const StarsEvaluetion({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
        (index) {
          if (index < media.floor()) {
            return const Icon(Icons.star, color: Colors.amber);
          } else if (index == media.floor() && media % 1 != 0) {
            return const Icon(Icons.star_half, color: Colors.amber);
          } else {
            return const Icon(Icons.star_border, color: Colors.amber);
          }
        },
      ),
    );
  }
}

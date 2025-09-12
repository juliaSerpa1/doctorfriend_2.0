import 'package:flutter/material.dart';

class CustomRadio<T> extends StatelessWidget {
  final Function(T) onChanged;
  final dynamic value;
  final dynamic groupValue;
  final String label;
  final Axis direction;
  final double fontSize;
  final double scale;
  const CustomRadio({
    super.key,
    required this.onChanged,
    required this.value,
    required this.groupValue,
    required this.label,
    this.direction = Axis.horizontal,
    this.fontSize = 19,
    this.scale = 1.4,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      // mainAxisAlignment: MainAxisAlignment.center,
      // mainAxisSize: MainAxisSize.min,
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      direction: direction,
      children: [
        Transform.scale(
          scale: scale, // Defina o fator de escala desejado
          child: Radio<T>(
            splashRadius: 20,
            activeColor: Theme.of(context).colorScheme.primary,
            value: value,
            groupValue: groupValue,
            onChanged: (T? value) {
              if (value != null) {
                onChanged(value);
              }
            },
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

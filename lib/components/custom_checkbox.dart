import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final Function(bool?) onChanged;
  final Widget label;
  final bool value;
  const CustomCheckbox({
    super.key,
    required this.onChanged,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.scale(
          scale: 1.2,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
          ),
        ),
        // const SizedBox(width: 5.0),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: label,
        )),
      ],
    );
  }
}

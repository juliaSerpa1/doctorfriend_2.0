import 'package:flutter/material.dart';

class ViewPassIcon extends StatelessWidget {
  const ViewPassIcon({
    super.key,
    required this.obscureText,
    required this.onPressed,
  });

  final bool obscureText;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: obscureText ? .5 : .8,
      child: IconButton(
        icon: Icon(!obscureText ? Icons.visibility : Icons.visibility_off),
        onPressed: onPressed,
      ),
    );
  }
}

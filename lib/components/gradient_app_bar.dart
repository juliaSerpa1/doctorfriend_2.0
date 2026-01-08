import 'package:flutter/material.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final List<Widget>? actions;
  final Widget? leading;
  final ShapeBorder? shape;

  const GradientAppBar({
    super.key,
    required this.title,
    this.centerTitle = true,
    this.actions,
    this.leading,
    this.shape,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      centerTitle: centerTitle,
      title: Text(title),
      shape: shape, 
      actions: actions,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
  decoration: const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color.fromRGBO(18, 59, 102, 1), // rgb(18, 59, 102)
        Color.fromRGBO(0, 0, 0, 1),     // rgb(0, 0, 0)
        Color.fromRGBO(14, 87, 43, 1),  // rgb(14, 87, 43)
      ],
    ),
  ),
),
    );
  }
}

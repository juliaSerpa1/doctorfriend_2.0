import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  final void Function() onPress;
  final IconData icon;
  final Color? color;
  const FloatingButton({
    super.key,
    required this.onPress,
    this.icon = Icons.add,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65.0,
      width: 65.0,
      child: FittedBox(
        child: FloatingActionButton(
          backgroundColor: color,
          onPressed: onPress,
          child: Icon(
            icon,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class MultiFloatingButton extends StatefulWidget {
  final List<MinFloatingButton> buttons;
  const MultiFloatingButton({
    super.key,
    required this.buttons,
  });
  @override
  State<MultiFloatingButton> createState() => _MultiFloatingButtonState();
}

class _MultiFloatingButtonState extends State<MultiFloatingButton> {
  bool _isExpanded = false;

  _expand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final buttons = widget.buttons;
    List<Widget> children() {
      List<Widget> els = [];
      for (int i = 0; i < buttons.length; i++) {
        final minFloatingButton = buttons[i];
        els.add(
          AlignButton(
            isExpanded: _isExpanded,
            minFloatingButton: minFloatingButton,
            index: i,
            expand: _expand,
          ),
        );
      }
      return els;
    }

    return Stack(
      children: children(),
    );
  }
}

class AlignButton extends StatelessWidget {
  const AlignButton({
    super.key,
    required this.isExpanded,
    required this.minFloatingButton,
    required this.index,
    required this.expand,
  });

  final bool isExpanded;
  final MinFloatingButton minFloatingButton;
  final int index;
  final Function() expand;

  @override
  Widget build(BuildContext context) {
    if (minFloatingButton.isMain) {
      return Align(
        alignment: Alignment.bottomRight,
        child: FloatingButton(
          onPress: expand,
          icon: isExpanded ? Icons.close : Icons.expand_less,
          color: isExpanded ? Colors.orange[800] : minFloatingButton.color,
        ),
      );
    }

    double distance = 75.0 * (index + 1);
    distance += 5;

    return Align(
      alignment: Alignment.bottomRight,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin:
            EdgeInsets.only(bottom: isExpanded ? distance : 4.5, right: 2.5),
        child: SizedBox(
          height: 60,
          width: 60,
          child: FloatingActionButton(
            heroTag: minFloatingButton.color.toString(),
            onPressed: minFloatingButton.onPressed,
            backgroundColor: minFloatingButton.color,
            elevation: 5.0,
            child: minFloatingButton.child,
          ),
        ),
      ),
    );
  }
}

class MinFloatingButton {
  final Function() onPressed;
  final Widget child;
  final Color? color;
  final bool isMain;

  const MinFloatingButton({
    required this.onPressed,
    required this.child,
    this.isMain = false,
    this.color,
  });
}

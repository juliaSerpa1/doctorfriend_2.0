import 'package:flutter/material.dart';

class InputSelect extends StatefulWidget {
  final String? label;
  final List<Widget> data;
  final Function(int) onChanged;
  final int selectedIndex;
  const InputSelect({
    super.key,
    this.label,
    required this.data,
    required this.onChanged,
    this.selectedIndex = 0,
  });

  @override
  State<InputSelect> createState() => _InputSelectState();
}

class _InputSelectState extends State<InputSelect> {
  late String selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.selectedIndex.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Stack(
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: DropdownButton<String>(
            itemHeight: 70.0,
            isExpanded: true,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSecondary,
            ),
            value: selectedOption,
            alignment: AlignmentDirectional.center,
            underline: Container(
              height: 60.0,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.0,
                  color: colorScheme.secondary.withOpacity(.5),
                ),
                borderRadius: BorderRadius.circular(26.0),
              ),
            ),
            iconEnabledColor: colorScheme.secondary,
            onChanged: (String? newValue) {
              if (newValue != null) {
                widget.onChanged(
                  int.parse(newValue),
                );
                setState(() {
                  selectedOption = newValue;
                });
              }
            },
            items: widget.data.map<DropdownMenuItem<String>>((Widget value) {
              return DropdownMenuItem<String>(
                value: widget.data
                    .indexWhere((element) => value == element)
                    .toString(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: value,
                ),
              );
            }).toList(),
          ),
        ),
        if (widget.label != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            margin: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              color: theme.canvasColor,
            ),
            child: Text(
              widget.label!,
              style: TextStyle(
                color: colorScheme.onSecondary.withOpacity(.6),
                fontSize: 15,
              ),
              // textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}

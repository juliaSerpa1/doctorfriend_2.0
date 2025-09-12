import 'package:flutter/material.dart';

class DateFillterNavigation extends StatelessWidget {
  final Function(DateTime) onChangedDate;
  final DateTime initialDate;
  const DateFillterNavigation(
    this.onChangedDate, {
    super.key,
    required this.initialDate,
  });

  @override
  Widget build(BuildContext context) {
    // String initialDateString = DateTime.now().year.toString();

    handleSelectDate(DateTime dateStart) {
      // initialDateString = initialDate.year.toString();

      onChangedDate(dateStart);
    }

    onAddOrSubtract(bool add) async {
      DateTime newDate;
      if (add) {
        newDate =
            DateTime(initialDate.year, 12, 30).add(const Duration(days: 2));
      } else {
        newDate = DateTime(initialDate.year).subtract(const Duration(days: 1));
      }

      handleSelectDate(newDate);
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => onAddOrSubtract(false),
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: colorScheme.onSecondary,
            ),
          ),
          Expanded(
            child: SizedBox(
              width: 150,
              height: 50,
              child: Center(
                child: Text(
                  initialDate.year.toString(),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () => onAddOrSubtract(true),
            icon: Icon(
              Icons.arrow_forward_ios_outlined,
              color: colorScheme.onSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

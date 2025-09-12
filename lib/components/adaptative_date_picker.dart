import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

class AdaptativeDatePicker extends StatelessWidget {
  final DateTime initialDate;
  final DateTime? finalDate;
  final Function(DateTime)? onDateChanged;
  final Function(DateTime, DateTime)? onDateRangeChanged;
  final DatePickerEntryMode initialEntryMode;
  final bool isRange;

  const AdaptativeDatePicker({
    required this.initialDate,
    this.finalDate,
    this.onDateChanged,
    this.onDateRangeChanged,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    this.isRange = false,
    super.key,
  });

  _showDatePicker(BuildContext context) {
    showDatePicker(
      initialEntryMode: initialEntryMode,
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
      builder: (ctx, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            disabledColor: Theme.of(context).colorScheme.tertiary,
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              surface: Theme.of(context).colorScheme.background,
            ),
          ),
          child: child ?? const Text("Error"),
        );
      },
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      onDateChanged!(pickedDate);
    });
  }

  _showDatePickerRange(BuildContext context) {
    showDateRangePicker(
      initialEntryMode: initialEntryMode,
      context: context,
      initialDateRange:
          DateTimeRange(start: initialDate, end: finalDate ?? initialDate),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
      builder: (ctx, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            disabledColor: Theme.of(context).colorScheme.tertiary,
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              surface: Theme.of(context).colorScheme.background,
            ),
          ),
          child: child ?? const Text("Error"),
        );
      },
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      onDateRangeChanged!(pickedDate.start, pickedDate.end);
    });
  }

  void _showDatePickerCupertino(context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: Colors.white,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: initialDate,
            minimumDate: DateTime(1900),
            maximumDate: DateTime.now().add(const Duration(days: 365)),
            onDateTimeChanged: onDateChanged!,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return !Platform.isIOS
        ? InkWell(onTap: () => _showDatePickerCupertino(context)
            // child: child,
            )
        : InkWell(
            onTap: () => !isRange
                ? _showDatePicker(context)
                : _showDatePickerRange(context),
            // child: child,
          );
  }
}

// DateFormat('dd/MM/y').format(initialDate!)

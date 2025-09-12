import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CustomInput extends StatelessWidget {
  final Map<String, dynamic>? formData;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? label;
  final String? objectKey;
  final TextInputType keyboardType;
  final String? Function(String)? validator;
  final bool requiredField;
  final bool isMoney;
  final bool done;
  final bool readOnly;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function()? onEditingComplete;
  final Function(PointerDownEvent)? onTapOutside;
  final bool obscureText;
  final Function(String)? onFieldSubmitted;
  final TextCapitalization textCapitalization;
  final int lines;
  final bool border;
  final String? hintText;
  final String? helperText;
  final Widget? suffixIcon;
  const CustomInput({
    super.key,
    this.formData,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.objectKey,
    this.label,
    this.validator,
    this.requiredField = false,
    this.isMoney = false,
    this.done = false,
    this.readOnly = false,
    this.controller,
    this.onChanged,
    this.obscureText = false,
    this.autofocus = false,
    this.onFieldSubmitted,
    this.textCapitalization = TextCapitalization.sentences,
    this.lines = 4,
    this.border = true,
    this.hintText,
    this.helperText,
    this.onEditingComplete,
    this.onTapOutside,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final List<TextInputFormatter> inputFormatters = [
      FilteringTextInputFormatter.digitsOnly,
      // Fit the validating format.
      //fazer o formater para dinheiro
      CurrencyInputFormatter(),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        autofocus: autofocus,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        onTapOutside: onTapOutside,
        obscureText: obscureText,
        controller: controller,
        inputFormatters: isMoney ? inputFormatters : null,
        readOnly: readOnly,
        onFieldSubmitted: onFieldSubmitted,
        // textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSecondary,
            ),
        initialValue:
            formData != null ? formData![objectKey]?.toString() : null,
        decoration: InputDecoration(
          helperText: helperText,
          hintText: hintText,
          labelText: requiredField ? "$label *" : label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: suffixIcon,
        ),
        textCapitalization: textCapitalization,
        focusNode: focusNode,
        keyboardType: keyboardType,
        maxLines: keyboardType == TextInputType.multiline ? lines : 1,
        onSaved: (value) => formData != null && objectKey != null
            ? formData![objectKey!] = value ?? ''
            : null,
        textInputAction: keyboardType == TextInputType.multiline
            ? TextInputAction.newline
            : done
                ? TextInputAction.done
                : TextInputAction.next,
        validator: (value) {
          final stringValue = value ?? '';

          if (requiredField && stringValue.trim().isEmpty) {
            final traslation = Translations.of(context).translate('input');
            return traslation["is_empty"];
          }

          if (validator != null) {
            return validator!(stringValue);
          }
          return null;
        },
      ),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    double value = double.parse(newValue.text);

    final formatter = NumberFormat.simpleCurrency(locale: "pt_Br");

    String newText = formatter.format(value / 100);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

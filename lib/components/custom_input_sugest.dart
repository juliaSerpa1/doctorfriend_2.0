import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/utils/tools_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:doctorfriend/utils/formater_util.dart';

class CustomInputSugest extends StatelessWidget {
  final String label;
  final TextInputType keyboardType;
  final String? Function(String)? validator;
  final bool requiredField;
  final TextEditingController controller;
  final Function(String)? handleRemove;
  final List<String> suggestions;
  final FocusNode? focus;
  final bool done;
  final TextCapitalization textCapitalization;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;

  const CustomInputSugest({
    super.key,
    this.keyboardType = TextInputType.text,
    required this.label,
    this.validator,
    this.requiredField = false,
    required this.controller,
    this.handleRemove,
    required this.suggestions,
    this.focus,
    this.done = false,
    this.textCapitalization = TextCapitalization.sentences,
    this.onChanged,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TypeAheadField(
        hideOnEmpty: true,
        suggestionsCallback: (pattern) {
          if (pattern.trim() == "") return suggestions;

          return suggestions
              .where(
                (element) => ToolsUtil.removeAccents(
                  element.toLowerCase(),
                ).contains(
                  ToolsUtil.removeAccents(
                    pattern.toLowerCase(),
                  ),
                ),
              )
              .toList();
        },
        builder: (context, controllerSuggest, focusNode) {
          return TextFormField(
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
            focusNode: focusNode,
            onChanged: (String text) {
              if (onChanged != null) {
                onChanged!(text);
              }
              controllerSuggest.text = text;
            },
            onFieldSubmitted: onFieldSubmitted,
            textAlign: TextAlign.left,
            controller: controller,
            textCapitalization: textCapitalization,
            decoration: InputDecoration(
              labelText: requiredField ? "$label *" : label,
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            keyboardType: keyboardType,
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
          );
        },
        itemBuilder: (context, suggestion) {
          return SuggestionContainer(
            handleRemove: handleRemove,
            suggestion: suggestion,
          );
        },
        onSelected: (value) {
          controller.text = value.toString();
          if (onChanged != null) {
            onChanged!(controller.text);
          }
        },
      ),
    );
  }
}

class SuggestionContainer extends StatefulWidget {
  final String suggestion;
  const SuggestionContainer({
    super.key,
    required this.handleRemove,
    required this.suggestion,
  });

  final Function(String p1)? handleRemove;

  @override
  State<SuggestionContainer> createState() => _SuggestionContainerState();
}

class _SuggestionContainerState extends State<SuggestionContainer> {
  bool _deleted = false;

  _handleDelete() {
    widget.handleRemove!(widget.suggestion);
    setState(() {
      _deleted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_deleted) {
      return const SizedBox();
    }
    return ListTile(
      title: Text(
        FormaterUtil.capitalize(widget.suggestion),
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      trailing: widget.handleRemove == null
          ? null
          : IconButton(
              onPressed: _handleDelete,
              icon: const Icon(Icons.highlight_remove_sharp),
            ),
    );
  }
}

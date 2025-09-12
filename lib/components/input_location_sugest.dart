import 'package:doctorfriend/data/constants.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:flutter/material.dart';
import 'package:doctorfriend/components/google_places_auto_complete_text_form_field/google_places_autocomplete_text_field.dart';

class InputLocationSugest extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String)? validator;
  final String label;
  final FocusNode? focus;
  final TextCapitalization textCapitalization;
  final Function(String)? onChanged;
  final bool done;
  final bool requiredField;
  final Function(String, String) setLatLng;
  const InputLocationSugest({
    super.key,
    required this.label,
    this.validator,
    this.requiredField = false,
    required this.controller,
    required this.setLatLng,
    this.focus,
    this.done = false,
    this.textCapitalization = TextCapitalization.sentences,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GooglePlacesAutoCompleteTextFormField(
        textEditingController: controller,
        googleAPIKey: mapsApiKey,
        debounceTime: 400, // defaults to 600 ms
        isLatLngRequired:
            true, // if you require the coordinates from the place details
        getPlaceDetailWithLatLng: (prediction) {
          if (prediction.lat != null && prediction.lng != null) {
            setLatLng(prediction.lat!, prediction.lng!);
          }
        }, // this callback is called when isLatLngRequired is true
        decoration: InputDecoration(
          labelText: requiredField ? "$label *" : label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
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
        // proxyURL: _yourProxyURL,
        maxLines: 1,
        overlayContainer: (child) => Material(
              elevation: 1.0,
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              child: child,
            ),
        itmClick: (prediction) {
          controller.text = prediction.description
                  ?.replaceAll("State of ", "")
                  .replaceAll("Brazil", "Brasil") ??
              "";
          controller.selection = TextSelection.fromPosition(
            TextPosition(offset: prediction.description?.length ?? 0),
          );
        });
  }
}

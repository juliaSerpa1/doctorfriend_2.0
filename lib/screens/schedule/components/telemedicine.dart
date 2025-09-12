import 'package:doctorfriend/components/modal.dart';
import 'package:doctorfriend/data/store.dart';
import 'package:doctorfriend/screens/schedule/components/telemedicine_worn.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/utils/preferences_util.dart';
import 'package:flutter/material.dart';

class Telemedicine extends StatelessWidget {
  final bool isTelemedicine;
  final Function(bool?) onChanged;
  const Telemedicine({
    super.key,
    required this.isTelemedicine,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    void onChangeCheckbox(bool? res) async {
      onChanged(res);
      final String preferencesUtil =
          await Store.getString(PreferencesUtil.showTelemedicineWorn, "false");
      if (res == true && preferencesUtil == 'false') {
        Modal(
          context,
          child: const TelemedicineWorn(),
        );
      }
    }

    final traslation = Translations.of(context).translate('telemedicine');
    return Column(
      children: [
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.scale(
              scale: 1.6,
              child: Checkbox(
                value: isTelemedicine,
                onChanged: onChangeCheckbox,
              ),
            ),
            Text(
              traslation["checkbox"],
              style: Theme.of(context).textTheme.bodyLarge,
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Opacity(
            opacity: .5,
            child: FittedBox(
              child: Text(
                isTelemedicine
                    ? traslation["is_telemedicine"]
                    : traslation["is_not_telemedicine"],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

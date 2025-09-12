import 'package:doctorfriend/components/modal.dart';
import 'package:doctorfriend/data/store.dart';
import 'package:doctorfriend/screens/schedule/components/telemedicine_worn.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/utils/preferences_util.dart';
import 'package:flutter/material.dart';

class TelemedicineSchedule extends StatelessWidget {
  final bool isTelemedicine;
  final Function(bool?) onChanged;
  const TelemedicineSchedule({
    super.key,
    required this.isTelemedicine,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final traslation =
        Translations.of(context).translate('schedule_telemedicine');
    void onChangeCheckbox(bool res) async {
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

    return Column(
      children: [
        const SizedBox(height: 15),
        Text(
          traslation["title"],
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Transform.scale(
                  scale: 1.5,
                  child: Checkbox(
                    value: !isTelemedicine,
                    onChanged: (_) => onChangeCheckbox(false),
                  ),
                ),
                Text(
                  traslation["not"],
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            const SizedBox(width: 15.0),
            Row(
              children: [
                Transform.scale(
                  scale: 1.5,
                  child: Checkbox(
                    value: isTelemedicine,
                    onChanged: (_) => onChangeCheckbox(true),
                  ),
                ),
                Text(
                  traslation["yes"],
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

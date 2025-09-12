import 'package:doctorfriend/components/loading_indicator.dart';
import 'package:doctorfriend/data/store.dart';
import 'package:doctorfriend/models/app_data.dart';
import 'package:doctorfriend/services/appData/suggestions_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/utils/preferences_util.dart';
import 'package:flutter/material.dart';

class TelemedicineWorn extends StatefulWidget {
  const TelemedicineWorn({super.key});

  @override
  State<TelemedicineWorn> createState() => _TelemedicineWornState();
}

class _TelemedicineWornState extends State<TelemedicineWorn> {
  AppData? _appData;
  bool _loading = false;
  bool _notShowAgan = false;
  _loadData() async {
    setState(() => _loading = true);
    _appData = await AppDataService().getAppData();

    setState(() => _loading = false);
  }

  _onChangeCheckbox(bool? checked) {
    setState(() {
      _notShowAgan = checked ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final traslation = Translations.of(context).translate('telemedicine_worn');
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Text(
            "👨‍⚕️ ${traslation["title"]}",
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 15.0),
          LoadingIndicator(
            loading: _loading,
            child: Text(
                (_appData?.telemedicineWorn ?? "").replaceAll('\\n', '\n')),
          ),
          const SizedBox(height: 15.0),
          Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                value: _notShowAgan,
                onChanged: _onChangeCheckbox,
              ),
              Text(
                traslation["not_show_again"],
                style: Theme.of(context).textTheme.bodySmall,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () async {
                  Store.saveString(
                    PreferencesUtil.showTelemedicineWorn,
                    _notShowAgan.toString(),
                  );
                  Navigator.of(context).pop();
                },
                child: Text(
                  traslation["close"],
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

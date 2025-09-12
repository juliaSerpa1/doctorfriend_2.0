import 'package:doctorfriend/components/callback.dart';
import 'package:doctorfriend/models/app_data.dart';
import 'package:doctorfriend/screens/auth/components/logo.dart';
import 'package:doctorfriend/services/appData/suggestions_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/utils/app_routes_util.dart';
import 'package:doctorfriend/utils/formater_util.dart';
import 'package:doctorfriend/utils/tools_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum SampleItem {
  theme,
}

class AuthTypeScreen extends StatefulWidget {
  final Function(Locale) setLocale;
  const AuthTypeScreen({
    super.key,
    required this.setLocale,
  });

  @override
  State<AuthTypeScreen> createState() => _AuthTypeScreenState();
}

class _AuthTypeScreenState extends State<AuthTypeScreen> {
  AppData? _appData;

  Future<void> _loadData() async {
    try {
      _appData = await AppDataService().getAppData();
      setState(() => {});
    } catch (e) {
      mounted ? Callback.snackBar(context) : {};
    }
  }

  void _goToFranchinsee() {
    ToolsUtil.launchURL(
      context,
      urlString: "https://wa.me/${FormaterUtil.toPhoneNumber(
        _appData?.appContact.franchiseeNumber ?? "",
      )}?text=${_appData?.franchiseeText ?? ""}",
    );
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final traslation = Translations.of(context).translate('auth_type_screen');

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    void changeLanguage(Locale language) {
      // Translation.updateTranslation(language);
      widget.setLocale(language);
    }

    List<DropdownMenuItem<SampleItem>> dropdownMenuItems() {
      List<DropdownMenuItem<SampleItem>> list = [];
      final translations = Translations.of(context);
      final locale = translations.locale;
      for (final language in Translations.localesAvaliable) {
        list.add(DropdownMenuItem<SampleItem>(
          onTap: () => changeLanguage(language.locale),
          value: SampleItem.theme,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                language.name,
                style: TextStyle(
                  color: colorScheme.onBackground,
                ),
              ),
              if (locale.languageCode == language.locale.languageCode)
                Icon(
                  Icons.check,
                  size: 25,
                  color: colorScheme.outline,
                ),
            ],
          ),
        ));
      }
      return list;
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                const Logo(),
                Positioned(
                  right: 20.0,
                  top: 20.0,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                        icon: Icon(
                          Icons.translate,
                          color: Theme.of(context).primaryIconTheme.color,
                        ),
                        items: dropdownMenuItems(),
                        onChanged: (_) {}),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Text(
              traslation["title"],
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(traslation["call"]),
            ),
            const SizedBox(height: 45),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                ),
                onPressed: () => context.push(AppRoutesUtil.webview),
                child: Text(
                  traslation["btn_1"],
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.go(AppRoutesUtil.login),
                child: Text(traslation["btn_2"]),
              ),
            ),
            if (_appData?.appContact.franchiseeNumber != null)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 15.0),
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: _goToFranchinsee,
                  label: Text(
                    traslation["btn_3"],
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

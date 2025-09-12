import 'package:doctorfriend/components/callback.dart';
import 'package:doctorfriend/components/loading_indicator.dart';
import 'package:doctorfriend/components/modal.dart';
import 'package:doctorfriend/models/app_data.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/screens/settings/common_questions_screen.dart';
import 'package:doctorfriend/services/appData/suggestions_service.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/utils/app_routes_util.dart';
import 'package:doctorfriend/utils/formater_util.dart';
import 'package:doctorfriend/utils/tools_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _loading = false;
  AppData? _appData;
  AppUser? user;

  _loadData() async {
    setState(() => _loading = true);
    try {
      _appData = await AppDataService().getAppData();
    } catch (e) {
      Callback.snackBar(context);
    }
    setState(() => _loading = false);
  }

  // void _showLoading(CustomerInfo customerInfo) async {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return PremiumDataScreen(customerInfo: customerInfo);
  //     },
  //   );
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final traslation = Translations.of(context).translate('settings');
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: Text(traslation["title"]),
      ),
      body: LoadingIndicator(
        loading: _loading,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  onTap: () => context.push(AppRoutesUtil.stickyNotes),
                  leading: const Icon(Icons.list),
                  title: Text(traslation["worns"]),
                ),
                StreamBuilder<AppUser?>(
                  stream: AuthService().userChanges,
                  builder: (context, snapshot) {
                    final AppUser? user = snapshot.data;
                    final bool isActive = user?.isPremium ?? false;
                    return Column(
                      children: [
                        ListTile(
                          onTap: () => ToolsUtil.launchURL(context,
                              urlString:
                                  "${_appData?.site ?? ""}/professional/${user?.id}"),
                          leading: const Icon(Icons.link),
                          title: Text(traslation["profile_on_site"]),
                        ),
                        if (_appData!.showSubscritions == true)
                          ListTile(
                            onTap: () => context.push(AppRoutesUtil.premium),
                            leading:
                                const Icon(Icons.workspace_premium_outlined),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (user != null)
                                  Expanded(
                                    child: Text(
                                      user.isFreePlan && !user.isPlanValid
                                          ? traslation[
                                              "subcription_status_free"]
                                          : isActive
                                              ? traslation[
                                                  "subcription_status_pro"]
                                              : traslation[
                                                  "subcription_status_show"],
                                    ),
                                  ),
                                if (isActive && user != null)
                                  Expanded(
                                    child: Text(
                                      user.isFreePlan && !user.isPlanValid
                                          ? traslation["days_left"].replaceAll(
                                              "{amount}",
                                              user.isFreePlanLesftDays
                                                  .toString(),
                                            )
                                          : user.planTypeFormated,
                                      style: TextStyle(
                                        color: user.isFreePlan
                                            ? theme.colorScheme.tertiary
                                            : theme.colorScheme.primary,
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        if (_appData!.showSubscritions == true)
                          ListTile(
                            textColor: theme.colorScheme.primary,
                            iconColor: theme.colorScheme.primary,
                            onTap: () => context.push(AppRoutesUtil.premium),
                            leading: const Icon(Icons.workspace_premium),
                            title: Text(traslation["available_plans"]),
                          ),
                      ],
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, top: 50.0, bottom: 10.0),
                  child: Text(
                    traslation["suport"],
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.tertiary,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                if (_appData?.manual.trim() != "")
                  ListTile(
                    onTap: () =>
                        buildModal(context, traslation["manual_modal_title"]),
                    title: Text(traslation["manual"]),
                  ),
                ListTile(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CommonQuestionsScreen(
                        commonQuestions: _appData?.commonQuestion ?? [],
                        suportNumber: _appData?.appContact.phoneSuport,
                      ),
                    ),
                  ),
                  title: Text(traslation["common_question"]),
                ),
                if (_appData?.termsURL != "")
                  ListTile(
                    onTap: () => ToolsUtil.launchURL(context,
                        urlString: _appData?.termsURL ?? ""),
                    title: Text(traslation["terms"]),
                  ),
                if (_appData?.privacyPolicyURL != "")
                  ListTile(
                    onTap: () => ToolsUtil.launchURL(context,
                        urlString: _appData?.privacyPolicyURL ?? ""),
                    title: Text(traslation["privacy_policy"]),
                  ),
                if (_appData?.appContact.phone != null)
                  ListTile(
                    onTap: () => ToolsUtil.launchURL(context,
                        urlString:
                            "https://wa.me/${FormaterUtil.toPhoneNumber(_appData?.appContact.phone ?? "")}"),
                    leading: const Icon(Icons.phone),
                    title: Text(_appData?.appContact.phone ?? ""),
                  ),
                if (_appData?.appContact.email != null)
                  ListTile(
                    onTap: () => ToolsUtil.launchURL(context,
                        urlString:
                            "mailto:${_appData?.appContact.email ?? ""}"),
                    leading: const Icon(Icons.email_outlined),
                    title: Text(_appData?.appContact.email ?? ""),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Modal buildModal(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Modal(
      context,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topRight,
                padding: const EdgeInsets.only(bottom: 10.0),
                child: IconButton(
                  onPressed: () => context.pop(),
                  icon: Icon(
                    Icons.close,
                    size: 36,
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
              Text(
                title,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              Text(_appData?.manual.replaceAll('\\n', '\n') ?? ""),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

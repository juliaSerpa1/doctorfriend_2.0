import 'package:doctorfriend/components/loading_indicator.dart';
import 'package:doctorfriend/models/app_data.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/screens/auth/components/logo.dart';
import 'package:doctorfriend/services/appData/suggestions_service.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/utils/app_routes_util.dart';
import 'package:doctorfriend/utils/tools_util.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:go_router/go_router.dart';

class UnauthorizedScreen extends StatefulWidget {
  const UnauthorizedScreen({super.key});

  @override
  State<UnauthorizedScreen> createState() => _UnauthorizedScreenState();
}

class _UnauthorizedScreenState extends State<UnauthorizedScreen> {
  AppData? _appData;

  Future<void> _loadData() async {
    _appData = await AppDataService().getAppData();
    if (mounted) {
      setState(() => {});
    }
  }

  Future<bool> get _isAuthorized async {
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  @override
  void initState() {
    super.initState();
    _isAuthorized;
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final traslation = Translations.of(context).translate('account_state');
    return StreamBuilder<AppUser?>(
        stream: AuthService().userChanges,
        builder: (context, snapshot) {
          final AppUser? user = snapshot.data;
          final bool loading =
              snapshot.connectionState == ConnectionState.waiting;
          final bool disabled = user?.disabled ?? false;
          final error = snapshot.error;
          return LoadingIndicator(
            loading: loading,
            error: error != null,
            errorMessage: error.toString(),
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 0,
              ),
              body: ListView(
                children: [
                  Stack(
                    children: [
                      const Logo(),
                      Positioned(
                        left: 0,
                        top: 0,
                        child: IconButton(
                          onPressed: () => context.go(AppRoutesUtil.appType),
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 26,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => context.push(AppRoutesUtil.user),
                              icon: const Icon(
                                Icons.person,
                                size: 26,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(
                            disabled
                                ? traslation["rejected_title"]
                                : traslation["analysis_title"],
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: disabled
                              ? Text(traslation["rejection_text"]
                                  .replaceAll("{name}", user?.name ?? ""))
                              : Text(traslation["analysis_text"]
                                  .replaceAll("{name}", user?.name ?? "")),
                        ),
                        if (_appData?.appContact.phone != null)
                          ListTile(
                            onTap: () => ToolsUtil.launchURL(context,
                                urlString:
                                    "https://wa.me/${_appData?.appContact.phone?.replaceAll("(", "").replaceAll(")", "").replaceAll("-", "").replaceAll(" ", "").trim() ?? ""}"),
                            leading: const Icon(Icons.message_outlined),
                            title: Text(_appData?.appContact.phone ?? ""),
                          ),
                        ListTile(
                          onTap: () => ToolsUtil.launchURL(context,
                              urlString:
                                  "mailto:${_appData?.appContact.email ?? ""}"),
                          leading: const Icon(Icons.email_outlined),
                          title: Text(_appData?.appContact.email ?? ""),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

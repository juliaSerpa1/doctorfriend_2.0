import 'dart:async';

import 'package:doctorfriend/components/callback.dart';
import 'package:doctorfriend/components/loading_indicator.dart';
import 'package:doctorfriend/exeption/handle_exception.dart';
import 'package:doctorfriend/models/app_data.dart';
import 'package:doctorfriend/models/app_offering.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/screens/auth/components/logo.dart';
import 'package:doctorfriend/services/appData/suggestions_service.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:doctorfriend/services/subscription/subscription.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/utils/app_routes_util.dart';
import 'package:doctorfriend/utils/formater_util.dart';
import 'package:doctorfriend/utils/tools_util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PremiumScreen extends StatefulWidget {
  final bool logout;
  final String plan;
  const PremiumScreen({
    super.key,
    this.logout = false,
    this.plan = 'premium',
  });

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  List<AppOffering> _offerings = SubscriptionApp().offerings;
  final AppUser _user = AuthService().currentUser!;
  String _selected = "premium";
  String? _actived;
  bool _loading = false;
  late Map<String, dynamic> _traslation;
  _bayPremium() async {
    try {
      PriceStripe? priceStripe;
      for (final offer in _offerings) {
        for (final price in offer.prices) {
          if (price.name.toLowerCase() == _selected) {
            priceStripe = price;
          }
        }
      }
      if (priceStripe == null) {
        Callback.snackBar(context, title: _traslation["error_offer_not_found"]);
        return;
      }
      if (priceStripe.id == "") {
        return Callback.snackBar(
          context,
          title: _traslation["error_offer_not_available"],
          error: false,
        );
      }
      setState(() {
        _loading = true;
      });
      final payment = await SubscriptionApp().bayPremium(
        priceStripe: priceStripe,
        userId: _user.id,
      );

      payment.listen((snap) async {
        final data = snap.data();

        if (data == null) {
          return;
        }

        final error = data['error'];
        final url = data['url'];

        if (error != null) {
          Callback.snackBar(context, title: error.toString());
          setState(() {
            _loading = false;
          });
        }

        if (url != null) {
          // We have a Stripe Checkout URL, let's redirect.
          await ToolsUtil.launchURL(context, urlString: url);
          setState(() {
            _loading = false;
          });
        }
      });
    } on HandleException catch (error) {
      Callback.snackBar(context, title: error.message);
    } catch (e) {
      Callback.snackBar(context);
    }
  }

  _onSelect(PriceStripe priceStripe) {
    setState(() {
      _selected = priceStripe.name.toLowerCase();
    });
  }

  List<Widget> offeringsWidget() {
    List<Widget> list = [];
    List<AppOffering> offerings = [..._offerings];

    //ordenar por preço

    for (final offer in offerings) {
      final pricesList = offer.pricesList();
      for (int i = 0; i < pricesList.length; i++) {
        final price = pricesList[i];
        final currentName = price.name.toLowerCase();
        list.add(PlanWidget(
          price,
          selected: currentName == _selected,
          onSelect: _onSelect,
          actived: currentName == _actived,
        ));
      }
    }

    return list;
  }

  StreamSubscription<List<AppOffering>>? _listem;
  // StreamSubscription<CustomerInfo?>? _listem2;

  _paymentStateChanges() {
    _listem = SubscriptionApp().offeringsChanges.listen((data) async {
      final List<AppOffering> customerInfo = data;

      _offerings = [...customerInfo];
      for (final val in _offerings) {
        if (val.name.toLowerCase().contains(widget.plan.toLowerCase())) {
          _selected = val.name.toLowerCase();
        }
      }
      setState(() {});
    });
  }

  AppData? _appData;
  _loadData() async {
    _appData = await AppDataService().getAppData();
  }

  _toPortalLink() async {
    try {
      setState(() => _loading = true);
      final link = await SubscriptionApp().createPortalLink();
      await ToolsUtil.launchURL(
        context,
        urlString: link,
      );
    } catch (e) {
      Callback.snackBar(context, title: e.toString());
    }
    setState(() => _loading = false);
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    final plan = _user.planType;
    if (plan != null) {
      _selected = plan;
      _actived = _user.planType;
    }

    _paymentStateChanges();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _traslation = Translations.of(context).translate('premium_screen');
  }

  @override
  void dispose() {
    _listem?.cancel();
    // _listem2?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  onPressed: () => context.pop(),
                  icon: const Icon(
                    Icons.arrow_back_sharp,
                    size: 26,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: widget.logout
                    ? Row(
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
                      )
                    : const SizedBox(),
              ),
            ],
          ),
          if (widget.logout)
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, top: 10.0, right: 15.0),
              child: Text(
                _traslation["call"],
                textAlign: TextAlign.center,
              ),
            ),
          PremiumPlan(
            _selected == 'masterclass',
            isGold: _selected == 'gold',
            isPremium: _selected == 'premium',
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: offeringsWidget(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: _offerings.isNotEmpty
                ? ElevatedButton(
                    onPressed: _loading
                        ? null
                        : _user.stripeUrl != null
                            ? _toPortalLink
                            : _bayPremium,
                    child: LoadingIndicator(
                      loading: _loading,
                      child: Text(
                        _user.stripeUrl != null
                            ? _traslation["manage_subscription"]
                            : _traslation["bay"],
                      ),
                    ),
                  )
                : Center(child: Text(_traslation["no_offer_available"])),
          ),
          const SizedBox(height: 30.0),
          if (widget.logout)
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: _traslation["contact_text_call"],
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    TextSpan(
                      text: 'suporte para assistência.',
                      style: const TextStyle(
                        color: Colors.blue,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => ToolsUtil.launchURL(context,
                            urlString:
                                "https://wa.me/${FormaterUtil.toPhoneNumber(_appData?.appContact.phoneSuport ?? "")}"),
                    ),
                  ],
                ),
              ),
            ),
          if (widget.logout)
            if (_appData?.termsURL != "")
              Center(
                child: TextButton(
                  onPressed: () => ToolsUtil.launchURL(
                    context,
                    urlString: _appData?.termsURL ?? "",
                  ),
                  child: Text(
                    _traslation["terms"],
                    style: const TextStyle(
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          if (widget.logout)
            if (_appData?.privacyPolicyURL != "")
              Center(
                child: TextButton(
                  onPressed: () => ToolsUtil.launchURL(context,
                      urlString: _appData?.privacyPolicyURL ?? ""),
                  child: Text(
                    _traslation["privacy_policy"],
                    style: const TextStyle(
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}

class PlanWidget extends StatelessWidget {
  final PriceStripe priceStripe;
  final bool selected;
  final bool actived;
  final Function(PriceStripe priceStripe) onSelect;
  const PlanWidget(
    this.priceStripe, {
    super.key,
    required this.actived,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final background = Theme.of(context).colorScheme.background;
    final onBackground = Theme.of(context).colorScheme.onBackground;
    final tertiary = Theme.of(context).colorScheme.tertiary;
    final secondary = Theme.of(context).colorScheme.secondary;
    final primary = Theme.of(context).colorScheme.primary;
    final traslation = Translations.of(context).translate('premium_screen');
    final textColor = selected ? background : onBackground;
    final textColorActive = selected ? secondary : primary;
    return Card(
      clipBehavior: Clip.hardEdge,
      color: selected ? onBackground : background,
      child: ListTile(
        onTap: () => onSelect(priceStripe),
        minVerticalPadding: 15.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  selected ? Icons.check_circle : Icons.circle,
                  color: selected ? secondary : tertiary,
                ),
                const SizedBox(width: 10.0),
                Text(
                  priceStripe.name,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: textColor),
                ),
              ],
            ),
            if (actived)
              Text(
                traslation["actived"],
                style: TextStyle(color: textColorActive),
              ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   offering.serverDescription,
              //   style: TextStyle(color: textColor),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Text(
                  traslation["offer_type_info"],
                  style: TextStyle(
                    color: textColor.withOpacity(.7),
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16.0,
                  ),
                  children: [
                    TextSpan(text: traslation["bay_for"]),
                    TextSpan(
                      text: priceStripe.formatarPreco(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    TextSpan(text: traslation["offer_type"]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PremiumPlan extends StatelessWidget {
  final bool full;
  final bool isGold;
  final bool isPremium;
  const PremiumPlan(
    this.full, {
    super.key,
    required this.isGold,
    required this.isPremium,
  });

  @override
  Widget build(BuildContext context) {
    final traslation = Translations.of(context).translate('premium_screen');
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        children: [
          Benefits(
            text: traslation["offer_0"],
            enabled: full,
          ),
          Benefits(
            text: traslation["offer_1"],
            enabled: full || isPremium,
          ),
          Benefits(
            text: traslation["offer_2"],
            enabled: full || isGold || isPremium,
          ),
          Benefits(
            text: traslation["offer_3"],
            enabled: full || isGold || isPremium,
          ),
          Benefits(
            text: traslation["offer_4"],
          ),
          Benefits(
            text: traslation["offer_5"],
          ),
          // Benefits(
          //   text: traslation["offer_6"],
          // ),
        ],
      ),
    );
  }
}

class Benefits extends StatelessWidget {
  final String text;
  final bool enabled;
  const Benefits({
    super.key,
    required this.text,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          enabled
              ? Icon(
                  Icons.check_circle,
                  color: colorScheme.secondary,
                )
              : Icon(
                  Icons.remove_circle_outlined,
                  color: colorScheme.error,
                ),
          const SizedBox(width: 15.0),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}

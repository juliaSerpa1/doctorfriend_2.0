import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorfriend/data/constants.dart';
import 'package:doctorfriend/models/app_offering.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/models/subscription.dart';
import 'package:doctorfriend/services/subscription/subscription.dart';
import 'package:doctorfriend/utils/firebase/firebase_firestore_util.dart';
import 'package:cloud_functions/cloud_functions.dart';

class StripeSubscriptionApp implements SubscriptionApp {
  final store = FirebaseFirestoreUtil.store;
  // final Locale _lang = Translations.currentLocale;
  @override
  Future<void> initPlatformState() async {}

  static dynamic _currentCustomerInfo;

  // static String? _premiumPriceString;
  static final List<AppOffering> _offerings = [];

  @override
  List<AppOffering> get offerings {
    return _offerings;
  }

  @override
  Stream<Subscription?> getSubscription(String userId) {
    final snapshots = store
        .collection('users')
        .doc(userId)
        .collection('subscriptions')
        .where('status', whereIn: ['trialing', 'active']).snapshots();

    return snapshots.map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        final data = doc.data();
        return Subscription(
          stripeLink: data["stripeLink"],
          metadata: data["metadata"],
          product: data["product"],
          quantity: data["quantity"],
          cancelAtPeriodEnd: data["cancel_at_period_end"],
          created: data["created"]?.toDate(),
          currentPeriodEnd: data["current_period_end"]?.toDate(),
          price: data["price"],
          prices: data["prices"].cast<String>(),
          items: data["items"]
              .map((item) {
                final Map<dynamic, dynamic> price = item["price"];
                final Map<dynamic, dynamic> product = price["product"];
                return ItemStripe(
                  metadata: item["metadata"],
                  quantity: item["quantity"],
                  discounts: item["discounts"],
                  created: item["created"],
                  name: item["price"]["nickname"],
                  price: Price(
                    taxBehavior: price["taxBehavior"],
                    product: ProductStripe(
                      metadata: product["metadata"],
                      images: product["images"]?.cast<String>(),
                      livemode: product["livemode"],
                      created: product["created"],
                      defaultPrice: product["default_price"],
                    ),
                  ),
                );
              })
              .toList()
              ?.cast<ItemStripe>(),
        );
      }

      return null;
    });
  }

  static MultiStreamController<dynamic>? _controller;
  static final _customerInfoStream = Stream<dynamic>.multi((controller) async {
    _controller = controller;
    _controller?.add(_currentCustomerInfo);
  });

  static MultiStreamController<List<AppOffering>>? _controllerOfferings;
  static final _offeringsStream =
      Stream<List<AppOffering>>.multi((controller) async {
    _controllerOfferings = controller;
    _controllerOfferings?.add(_offerings);
  });

  @override
  Future<void> listenCustomerInfo(AppUser? user) async {
    if (user == null) return;

    loadOfferings();
    // _premiumPriceString = _offerings?.storeProduct.priceString;
  }

  @override
  Stream<dynamic> get customerInfoChanges {
    return _customerInfoStream;
  }

  @override
  Stream<List<AppOffering>> get offeringsChanges {
    return _offeringsStream;
  }

  Future<void> loadOfferings() async {
    try {
      final querySnapshot = await store
          .collection('products-stripe')
          .where('active', isEqualTo: true)
          .get();
      final List<AppOffering> offers = [];
      for (var doc in querySnapshot.docs) {
        final offer = doc.data();
        final priceSnapshot = await doc.reference
            .collection('prices')
            .where('active', isEqualTo: true)
            .get();
        offers.add(
          AppOffering(
            id: doc.id,
            name: offer["name"],
            prices: priceSnapshot.docs
                .map((val) {
                  final price = val.data();
                  return PriceStripe(
                    id: val.id,
                    name: price["description"] ?? "",
                    currency: price["currency"],
                    unitAmount: price["unit_amount"],
                  );
                })
                .toList()
                .cast<PriceStripe>(),
          ),
        );
      }
      offers.sort(
        (a, b) => a.prices[0].unitAmount > b.prices[0].unitAmount ? 1 : 0,
      );
      _offerings.clear();
      _offerings.addAll([...offers]);
      _controllerOfferings?.add(_offerings);
    } catch (error) {
      // print(error);
    }
  }

  @override
  Future<Stream<DocumentSnapshot<Map<String, dynamic>>>> bayPremium({
    required PriceStripe priceStripe,
    required String userId,
  }) async {
    final docRef = await store
        .collection('users')
        .doc(userId)
        .collection('checkout_sessions')
        .add({
      // "collect_shipping_address": false,
      'price': priceStripe.id,
      'success_url': "$site/success-subscription",
      'cancel_url': "$site/cancel-subscription",
      "metadata": {
        "item": priceStripe.name.toLowerCase(),
      },
    });

    return docRef.snapshots();
  }

  @override
  Future<String> createPortalLink() async {
    final HttpsCallable function =
        FirebaseFunctions.instanceFor(region: 'southamerica-east1')
            .httpsCallable('ext-firestore-stripe-payments-createPortalLink');

    final response = await function.call(<String, dynamic>{
      'returnUrl': "$site/",
      'locale': 'auto', // Optional, defaults to "auto"
      // 'configuration': 'bpc_1JSEAKHYgolSBA358VNoc2Hs', // Optional
    });

    final data = response.data as Map<String, dynamic>;
    final url = data['url'] as String;
    return url;
  }
}

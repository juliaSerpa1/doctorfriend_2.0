import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorfriend/models/app_offering.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/models/subscription.dart';
import 'package:doctorfriend/services/subscription/stripe_subscription.dart';

abstract class SubscriptionApp {
  Future<void> initPlatformState();

  Future<void> listenCustomerInfo(AppUser? user);
  Future<Stream<DocumentSnapshot<Map<String, dynamic>>>> bayPremium({
    required PriceStripe priceStripe,
    required String userId,
  });

  Stream<dynamic> get customerInfoChanges;
  List<AppOffering> get offerings;

  Stream<Subscription?> getSubscription(String userId);

  Stream<List<AppOffering>> get offeringsChanges;
  Future<String> createPortalLink();

  factory SubscriptionApp() {
    return StripeSubscriptionApp();
  }
}

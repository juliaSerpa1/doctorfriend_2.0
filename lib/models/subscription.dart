import 'package:cloud_firestore/cloud_firestore.dart';

class Subscription {
  final String stripeLink;
  final Map<String, dynamic> metadata;
  final DocumentReference product;
  final String? role;
  final int quantity;
  final bool cancelAtPeriodEnd;
  final DateTime? canceledAt;
  final DateTime created;
  final DateTime? trialEnd;
  final DateTime currentPeriodEnd;
  final DocumentReference price;
  final DateTime? trialStart;
  final List<String> prices;
  final List<ItemStripe> items;

  Subscription({
    required this.stripeLink,
    required this.metadata,
    required this.product,
    this.role,
    required this.quantity,
    required this.cancelAtPeriodEnd,
    this.canceledAt,
    required this.created,
    this.trialEnd,
    required this.currentPeriodEnd,
    required this.price,
    this.trialStart,
    required this.prices,
    required this.items,
  });

  factory Subscription.fromMap(Map<String, dynamic> map) {
    return Subscription(
      stripeLink: map['stripeLink'],
      metadata: Map<String, dynamic>.from(map['metadata']),
      product: map['product'],
      role: map['role'],
      quantity: map['quantity'],
      cancelAtPeriodEnd: map['cancel_at_period_end'],
      canceledAt: map['canceled_at']?.toDate(),
      created: map['created']?.toDate(),
      trialEnd: map['trial_end']?.toDate(),
      currentPeriodEnd: map['current_period_end']?.toDate(),
      price: map['price'],
      trialStart: map['trial_start']?.toDate(),
      prices: List<String>.from(map['prices']),
      items: (map['items'] as List)
          .map((itemMap) => ItemStripe.fromMap(itemMap))
          .toList(),
    );
  }
}

class ItemStripe {
  final Map<String, dynamic> metadata;
  final int quantity;
  final List<dynamic> discounts;
  final int created;
  final Price price;
  final String name;

  ItemStripe({
    required this.metadata,
    required this.quantity,
    required this.discounts,
    required this.created,
    required this.price,
    required this.name,
  });

  factory ItemStripe.fromMap(Map<String, dynamic> map) {
    return ItemStripe(
      metadata: Map<String, dynamic>.from(map['metadata']),
      quantity: map['quantity'],
      discounts: List<dynamic>.from(map['discounts']),
      created: map['created'],
      name: map['name'],
      price: Price.fromMap(map['price']),
    );
  }
}

class Price {
  final String? taxBehavior;
  final ProductStripe product;

  Price({
    required this.taxBehavior,
    required this.product,
  });

  factory Price.fromMap(Map<String, dynamic> map) {
    return Price(
      taxBehavior: map['tax_behavior'],
      product: ProductStripe.fromMap(map['product']),
    );
  }
}

class ProductStripe {
  final Map<String, dynamic> metadata;
  final List<String> images;
  final bool livemode;
  final int created;
  final String defaultPrice;

  ProductStripe({
    required this.metadata,
    required this.images,
    required this.livemode,
    required this.created,
    required this.defaultPrice,
  });

  factory ProductStripe.fromMap(Map<String, dynamic> map) {
    return ProductStripe(
      metadata: Map<String, dynamic>.from(map['metadata']),
      images: List<String>.from(map['images']),
      livemode: map['livemode'],
      created: map['created'],
      defaultPrice: map['default_price'],
    );
  }
}

class UserService {
  final String service;
  final String? price;
  final bool priceFixed;

  const UserService({
    required this.service,
    required this.price,
    required this.priceFixed,
  });

  Map<String, dynamic> get toMap {
    return {
      "service": service,
      "price": price,
      "priceFixed": priceFixed,
    };
  }

  String get string {
    //${priceFixed ? "A partir de " : ""}
    if (price == null) {
      return "$service ";
    }
    return "$service  -  ${price!}";
  }
}

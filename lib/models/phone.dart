class Phone {
  final String number;
  final bool verified;

  const Phone({
    required this.number,
    required this.verified,
  });

  Map<String, dynamic> get toMap {
    return {
      "number": number,
      "verified": verified,
    };
  }
}

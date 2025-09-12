class Links {
  final String? site;
  final String? facebook;
  final String? instagram;
  final String? twitter;

  const Links({
    required this.site,
    required this.facebook,
    required this.instagram,
    required this.twitter,
  });

  Map<String, dynamic> get toMap {
    return {
      "site": site,
      "facebook": facebook,
      "instagram": instagram,
      "twitter": twitter,
    };
  }
}

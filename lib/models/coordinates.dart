class Coordinates {
  final double lat;
  final double lng;

  const Coordinates({
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> get toMap {
    return {
      "lat": lat,
      "lng": lng,
    };
  }
}

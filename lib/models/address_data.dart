import 'package:doctorfriend/models/coordinates.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const LatLng defoultLatLng = LatLng(-23.981860, -46.173599);

class AddressData {
  final String id;
  final String userId;
  final String? street;
  final int? number;
  // final String? city;
  // final String? state;
  // final String? country;
  final String? complement;
  final String? zipCode;
  final String? neighborhood;
  final double lat;
  final double lng;
  final Coordinates? coordinates;
  final String local; //endereço para pesquisa no site

  const AddressData({
    required this.id,
    required this.userId,
    required this.street,
    required this.number,
    // required this.city,
    // required this.state,
    // required this.country,
    required this.complement,
    required this.zipCode,
    required this.neighborhood,
    required this.local,
    required this.lat,
    required this.lng,
    required this.coordinates,
  });

  LatLng get toLatLng {
    return LatLng(lat, lng);
  }

  Map<String, dynamic> get toMap {
    return {
      "userId": userId,
      "street": street,
      "number": number,
      // "city": city?.trimRight().toLowerCase(),
      // "state": state?.trimRight().toLowerCase(),
      // "country": country?.trimRight().toLowerCase(),
      "complement": complement,
      "zipCode": zipCode,
      "neighborhood": neighborhood?.trimRight().toLowerCase(),
      "lng": lng,
      "lat": lat,
      "local": local,
      "coordinates": coordinates == null
          ? null
          : {
              "lat": coordinates?.lat,
              "lng": coordinates?.lng,
            }
    };
  }

  String get addressString {
    String address = "";
    if (street != null) {
      address += "$street, ";
    }
    if (neighborhood != null) {
      address += "${neighborhood ?? ""}, ";
    }

    if (street != null) {
      address += "${number ?? 'SN'} ";
    }

    if (complement != null) {
      address += "- $complement ";
    }

    // if (city != null) {
    //   address += " $city ";
    // }

    // if (state != null) {
    //   address += "- $state ";
    // }

    // if (country != null) {
    //   address += ", $country";
    // }

    address += " $local ";

    // if (zipCode != null) {
    //   address += "\nCEP: $zipCode";
    // }

    return address;
  }
}

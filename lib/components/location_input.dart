import 'package:doctorfriend/components/callback.dart';
import 'package:doctorfriend/models/address_data.dart';
import 'package:doctorfriend/screens/map_screen.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LocationInput extends StatefulWidget {
  final Function(LatLng) onSelectPosition;
  final LatLng? latLngSelected;

  final bool viewOnly;
  const LocationInput(
    this.onSelectPosition, {
    super.key,
    this.latLngSelected,
    this.viewOnly = false,
  });

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  LatLng? _latLngSelected;
  bool _loading = false;
  late Map<String, dynamic> _traslation;
  Future<void> _getCurrentUserLocation(BuildContext context) async {
    setState(() => _loading = true);

    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        throw _traslation["error_location_unabled"];
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          throw _traslation["error_location_denied"];
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        throw _traslation["error_location_denied_forever"];
      }

      final locData = await Geolocator.getCurrentPosition();

      final latLang = LatLng(
        locData.latitude,
        locData.longitude,
      );
      widget.onSelectPosition(latLang);
      setState(() {
        _latLngSelected = latLang;
      });
    } catch (e) {
      Callback.snackBar(
        context,
        title: e.toString(),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _selectOnMap() async {
    final user = AuthService().currentUser;
    LatLng defoultLatLngStart = defoultLatLng;
    if (user != null) {
      final pos = user.addresses[0].toLatLng;
      defoultLatLngStart = pos;
    }
    setState(() => _loading = true);
    final LatLng? selectedPosition = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          initialLocation:
              _latLngSelected ?? widget.latLngSelected ?? defoultLatLngStart,
        ),
      ),
    );

    if (selectedPosition == null) return setState(() => _loading = false);

    widget.onSelectPosition(selectedPosition);

    setState(() {
      _latLngSelected = selectedPosition;
      _loading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _traslation = Translations.of(context).translate('location_input');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_loading)
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Theme.of(context).colorScheme.tertiary.withOpacity(.5),
              ),
            ),
            height: 350,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        else
          MapImage(
            viewOnly: widget.viewOnly,
            latLngSelected: _latLngSelected ?? widget.latLngSelected,
            traslation: _traslation,
          ),
        if (!widget.viewOnly)
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.location_on),
                label: Text(_traslation["btn_current_location"]),
                onPressed: () => _getCurrentUserLocation(context),
              ),
              TextButton.icon(
                icon: const Icon(Icons.map),
                label: Text(_traslation["btn_select_on_map"]),
                onPressed: _selectOnMap,
              ),
            ],
          )
      ],
    );
  }
}

class MapImage extends StatelessWidget {
  const MapImage({
    super.key,
    required this.viewOnly,
    required this.latLngSelected,
    required this.traslation,
  });

  final bool viewOnly;
  final LatLng? latLngSelected;
  final Map<String, dynamic> traslation;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 400),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.tertiary.withOpacity(.5),
        ),
      ),
      child: latLngSelected == null
          ? Text(traslation["error_unselected_location"])
          : MapScreen(
              initialLocation: latLngSelected!,
              isReadOnly: true,
              onlyMap: true,
            ),
    );
  }
}

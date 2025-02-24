import 'package:flutter_map/flutter_map.dart' as flutterMap;
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';


class LocationManager {
  final flutterMap.MapController mapController;
  List<flutterMap.Marker> markers;

  LocationManager({required this.mapController, required this.markers});

  // Méthode pour obtenir la position actuelle
  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Vérifier si les services de localisation sont activés
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Les services de localisation ne sont pas activés
      return;
    }

    // Demander les permissions de localisation
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions refusées
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions refusées de manière permanente
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Récupérer la position actuelle
    Position position = await Geolocator.getCurrentPosition();

    LatLng currentPosition = LatLng(position.latitude, position.longitude);

    // Ajouter un marqueur bleu rond à la position de l'utilisateur
    markers.add(
      flutterMap.Marker(
        point: currentPosition,
        width: 60,
        height: 60,
        child: const Icon(
          Icons.circle,
          size: 20,
          color: Colors.blue,
        ),
      ),
    );

    // Centrer la carte sur la position de l'utilisateur
    mapController.move(currentPosition, 15.0);
  }
}
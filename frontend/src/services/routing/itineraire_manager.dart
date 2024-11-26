// itineraire_manager.dart
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart' as flutterMap;
import '../location_manager.dart';

class ItineraireManager extends LocationManager {
  final List<List<double>> userCoordinates = []; // Liste de listes pour conserver les coordonnées

  ItineraireManager({
    required flutterMap.MapController mapController,
    required List<flutterMap.Marker> markers,
  }) : super(mapController: mapController, markers: markers);

  // Méthode pour récupérer la position et l'ajouter à la liste
  Future<void> addCurrentLocationToList() async {
    try {
      // Appeler la méthode héritée pour obtenir la position
      await getCurrentLocation();

      // Récupérer la dernière position ajoutée
      if (markers.isNotEmpty) {
        flutterMap.Marker lastMarker = markers.last;
        LatLng position = lastMarker.point;

        // Ajouter les coordonnées à la liste
        userCoordinates.add([position.latitude, position.longitude]);
      }
    } catch (e) {
      print("Erreur lors de la récupération de la localisation : $e");
    }
  }
}
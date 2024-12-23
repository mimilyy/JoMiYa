import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';

class ItineraireManager {
  final MapController mapController;
  final List<Marker> markers;
  final List<Polyline> polylines; // Nouvelle liste pour les polylines

  ItineraireManager({
    required this.mapController,
    required this.markers,
    required this.polylines,
  });

  Future<void> calculateItinerary(LatLng start, LatLng end, {Function()? onUpdate}) async {
    final url =
        'http://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final routes = data['routes'] as List;
        if (routes.isNotEmpty) {
          final route = routes[0];
          final geometry = route['geometry']['coordinates'] as List;

          // Convertir la géométrie en une liste de LatLng
          final polylinePoints = geometry
              .map<LatLng>((point) => LatLng(point[1] as double, point[0] as double))
              .toList();

          // Centrer la carte sur le début du trajet
          mapController.move(start, 10);

          // Ajouter des marqueurs pour le début et la fin
          markers.clear();
          markers.addAll([
            Marker(
              point: start,
              width: 40.0,
              height: 40.0,
              child: const Icon(Icons.location_on, color: Colors.blue),
            ),
            Marker(
              point: end,
              width: 40.0,
              height: 40.0,
              child: const Icon(Icons.location_on, color: Colors.red),
            ),
          ]);

          // Ajouter une polyline pour l'itinéraire
          polylines.clear();
          polylines.add(
            Polyline(
              points: polylinePoints,
              strokeWidth: 4.0,
              color: Colors.blue,
            ),
          );

          // Appeler le callback pour rafraîchir la carte
          if (onUpdate != null) {
            onUpdate();
          }
        } else {
          print('Aucun itinéraire trouvé.');
        }
      } else {
        print('Erreur API OSRM : ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur lors de la récupération des données OSRM : $e');
    }
  }
}

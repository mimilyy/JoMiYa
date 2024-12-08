import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart' as flutterMap;
import 'package:flutter/material.dart';


class ItineraireManager {
  final flutterMap.MapController mapController;
  final List<flutterMap.Marker> markers;

  
  ItineraireManager({required this.mapController, required this.markers});
  
  Future<void> calculateItinerary(LatLng start, LatLng end,{Function()? onUpdate}) async {
    // driving (transport)
    final url =
        'http://router.project-osrm.org/route/v1/&profile/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson';

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
              .map<LatLng>(
                  (point) => LatLng(point[1] as double, point[0] as double))
              .toList();

          // Centrer la carte sur le début du trajet
          mapController.move(start, 10);

          // Ajouter des marqueurs pour le début et la fin
          markers.addAll([
            flutterMap.Marker(
              point: start,
              width: 40.0,
              height: 40.0,
              child: const Icon(
                Icons.location_on, 
                color: Colors.blue),
              ),
            flutterMap.Marker(
              point: end,
              child:const Icon(
                Icons.location_on, 
                color: Colors.red),
              ),
          ]);

          // Ajouter une polyline pour l'itinéraire
          final polylineLayer = flutterMap.PolylineLayer(
            polylines: [
              flutterMap.Polyline(
                points: polylinePoints,
                strokeWidth: 4.0,
                color: Colors.blue,
              ),
            ],
          );

          // Mettre à jour la carte
          markers.addAll(polylineLayer.polylines
              .map((polyline) => flutterMap.Marker(
                    point: polyline.points.first,
                    child: Container(),
                  ))
              .toList());
              // Appeler le callback pour indiquer la fin de l'opération

          // Rafraîchir la carte
        } else {
          print('Aucun itinéraire trouvé.');
        }

        //////// TEST DE L'API //////////////
        print('Réponse brute de l\'API : ${response.body}');
        /////////////////////////////////////
        ///
      } else {
        print('Erreur API OSRM : ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur lors de la récupération des données OSRM : $e');
    }
  }
}

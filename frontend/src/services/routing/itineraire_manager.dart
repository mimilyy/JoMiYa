import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class ItineraireManager {
  final MapController mapController;
  final List<Marker> markers;
  final List<Polyline> polylines; 

  ItineraireManager({
    required this.mapController,
    required this.markers,
    required this.polylines,
  });

  Future<void> calculateItinerary(LatLng start, LatLng end, {Function()? onUpdate}) async {
    final apiKey = '8d56f223-f6ee-4b0d-986b-fc06119f452a'; 
    final url =
        'https://graphhopper.com/api/1/route?point=${start.latitude},${start.longitude}&point=${end.latitude},${end.longitude}&vehicle=foot&key=$apiKey';
    
    // Print des coordonnées des points de départ et d'arrivée
    print('Start Latitude: ${start.latitude}, Start Longitude: ${start.longitude}');
    print('End Latitude: ${end.latitude}, End Longitude: ${end.longitude}');
    print('');
    print('');
    try {
      print('URL appelée : $url');
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print('Réponse reçue : ${response.body}');
        print('');
        print('');
        final data = json.decode(response.body);
        final paths = data['paths'] as List;
        if (paths.isNotEmpty) {
          final path = paths[0];
          final encodedPolyline = path['points'];
          print('les coordonnées brut : $encodedPolyline');
          print('');
          print('');
          final polylinePoints = _decodePolyline(encodedPolyline);
          print('les coordonnées décodées $polylinePoints');
          print('');
          print('');

          mapController.move(start, 10);

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

          polylines.clear();
          polylines.add(
            Polyline(
              points: polylinePoints,
              strokeWidth: 4.0,
              color: Colors.blue,
            ),
          );

          if (onUpdate != null) {
            onUpdate();
          }
        } else {
          print('Aucun itinéraire trouvé.');
        }
      } else {
        print('Erreur API GraphHopper : ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur de connexion : $e');
    }
  }

  // Fonction pour décoder la polyline encodée
  List<LatLng> _decodePolyline(String encodedPolyline) {
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPoints = polylinePoints.decodePolyline(encodedPolyline);

    // Conversion des points décodés en List<LatLng>
    List<LatLng> latLngList = decodedPoints.map((point) {
      return LatLng(point.latitude, point.longitude);
    }).toList();

    return latLngList;
  }
}
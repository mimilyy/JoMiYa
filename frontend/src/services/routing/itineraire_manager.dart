// itineraire_manager.dart
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class ItineraireManager {
  static void showItineraireOptions(BuildContext context, LatLng destination) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Options d\'itinéraires pour se rendre à cette destination :',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                leading: Icon(Icons.directions_walk),
                title: Text('À pied'),
                onTap: () {
                  Navigator.pop(context); // Fermer la fenêtre modale
                  // Logique de navigation à pied
                },
              ),
              ListTile(
                leading: Icon(Icons.directions_car),
                title: Text('En voiture'),
                onTap: () {
                  Navigator.pop(context);
                  // Logique de navigation en voiture
                },
              ),
              ListTile(
                leading: Icon(Icons.directions_transit),
                title: Text('Transports en commun'),
                onTap: () {
                  Navigator.pop(context);
                  // Logique de navigation via transports en commun
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
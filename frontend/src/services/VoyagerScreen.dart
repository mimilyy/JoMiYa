import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutterMap;
import 'package:latlong2/latlong.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'location_manager.dart';
import '../utils/theme/theme.dart';
import '../ui/pages/navigation_menu.dart';
import '../ui/components/search_manager.dart';

class VoyagerScreen extends StatefulWidget {
  @override
  _VoyagerScreenState createState() => _VoyagerScreenState();
}

class _VoyagerScreenState extends State<VoyagerScreen> {
  final flutterMap.MapController _mapController = flutterMap.MapController(); // Contrôleur pour flutter_map
  List<flutterMap.Marker> _markers = []; // Liste des marqueurs
  late LocationManager _locationManager; // Instance du gestionnaire de localisation
  final GlobalKey<SearchManagerState> _searchManagerKey = GlobalKey<SearchManagerState>(); // Ajout de la clé

  @override
  void initState() {
    super.initState();
    // Initialiser le gestionnaire de localisation
    _locationManager = LocationManager(mapController: _mapController, markers: _markers);
    _locationManager.getCurrentLocation(); // Récupérer la position actuelle
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JoMiYa Corporation'),
      ),
      body: Stack( // Utiliser un Stack pour superposer le bouton sur la carte
        children: [
          Column(
            children: [
              // Intégration de la barre de recherche avec gestion des recherches récentes
              SearchManager(
                key: _searchManagerKey, // Ajout de la clé ici
                mapController: _mapController,
                markers: _markers,
              ),
              Expanded(
                child: flutterMap.FlutterMap( // Affichage de la carte
                  mapController: _mapController,
                  options: flutterMap.MapOptions(
                    initialCenter: LatLng(48.864716, 2.349014), // Latitude et longitude de Paris
                    initialZoom: 11,
                  ),
                  children: [
                    openStreetMapTileLayer,
                    flutterMap.MarkerLayer(markers: _markers),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                _locationManager.getCurrentLocation(); // Centrer la carte sur la localisation actuelle
              },
              child: const Icon(Icons.location_searching), // Icône pour le bouton
              backgroundColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

// TileLayer pour les tuiles de la carte OpenStreetMap
flutterMap.TileLayer get openStreetMapTileLayer => flutterMap.TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
);
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutterMap;
import 'package:jomiya_projet/frontend/src/ui/pages/favorites_controller.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'location_manager.dart';
import '../utils/theme/theme.dart';
import '../ui/components/search_manager.dart';
import 'routing/itineraire_manager.dart';
import 'package:jomiya_projet/frontend/src/ui/pages/navigation_menu.dart';
import 'package:get/get.dart';

class VoyagerScreen extends StatefulWidget {
  @override
  _VoyagerScreenState createState() => _VoyagerScreenState();
}

class _VoyagerScreenState extends State<VoyagerScreen> {
  final FavoritesController favoritesController = Get.find<FavoritesController>();
  

  final flutterMap.MapController _mapController = flutterMap.MapController();
  List<flutterMap.Marker> _markers = [];
  late LocationManager _locationManager;
  late ItineraireManager _itineraireManager;
  final GlobalKey<SearchManagerState> _searchManagerKey = GlobalKey<SearchManagerState>();
  final List<flutterMap.Polyline> _polylines = [];
  String? _currentPlaceName;
  List<Map<String, dynamic>> _favorites = []; // Local favorites list
  bool _locationUpdated = false;

  @override
  void initState() {
    super.initState();
    _locationManager = LocationManager(mapController: _mapController, markers: _markers);
    _itineraireManager = ItineraireManager(
      mapController: _mapController,
      markers: _markers,
      polylines: _polylines,
    );
    _loadFavorites();

    _mapController.mapEventStream.listen((event) {
      if (event is flutterMap.MapEventMoveStart || 
          event is flutterMap.MapEventMove || 
          event is flutterMap.MapEventMoveEnd || 
          event is flutterMap.MapEventDoubleTapZoom || 
          event is flutterMap.MapEventScrollWheelZoom || 
          event is flutterMap.MapEventNonRotatedSizeChange) {
        _locationUpdated = true;
      }
    });
  }

  // Getter to expose _favorites
  List<Map<String, dynamic>> get favorites => _favorites;


  // Load favorites from Firestore or local storage
  void _loadFavorites() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentReference userRef = FirebaseFirestore.instance.collection('Users').doc(user.uid);
      QuerySnapshot favoritesSnapshot = await userRef.collection('favorites').get();

      setState(() {
        _favorites = favoritesSnapshot.docs.map((doc) {
          return {
            'name': doc['name'],
            'latitude': doc['latitude'],
            'longitude': doc['longitude']
          };
        }).toList();
      });
    } else {
      // No action needed, as favorites will stay in memory.
    }
  }
void onLocationSelected(LatLng location, String? placeName) {
  print("🔄 Mise à jour du contrôleur : $location, $placeName");
  final controller = Get.find<NavigationController>();
  controller.selectedLocation.value = location;
  controller.selectedPlaceName.value = placeName ?? "Lieu inconnu";
}

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NavigationController>();

    return Scaffold(
      appBar: AppBar(title: const Text('JoMiYa Corporation')),
      body: Stack(
        children: [
          Column(
            children: [
            SearchManager(
              mapController: _mapController,
              markers: _markers,
              onLocationSelected: (LatLng location, String? placeName) {
                print("✅ Lieu sélectionné : $placeName, Coordonnées : $location");

                final controller = Get.find<NavigationController>();
                controller.selectedLocation.value = location;
                controller.selectedPlaceName.value = placeName ?? "Lieu inconnu";

                print("📍 `selectedLocation` mis à jour : ${controller.selectedLocation.value}");
                print("🏷 `selectedPlaceName` mis à jour : ${controller.selectedPlaceName.value}");

                _zoomToLocation(location, placeName);
                _locationUpdated = true;
              },
            ),
              Expanded(
                child: Obx(() {
                  LatLng? selectedLocation = controller.selectedLocation.value;
                  String? selectedPlaceName = controller.selectedPlaceName.value;

                  if (selectedLocation != null && !_locationUpdated) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _zoomToLocation(selectedLocation, selectedPlaceName);
                    });
                  }

                  return flutterMap.FlutterMap(
                    mapController: _mapController,
                    options: const flutterMap.MapOptions(
                      initialCenter: LatLng(48.864716, 2.349014),
                      initialZoom: 11,
                    ),
                    children: [
                      openStreetMapTileLayer,
                      flutterMap.MarkerLayer(markers: _markers),
                      flutterMap.PolylineLayer(polylines: _polylines),
                    ],
                  );
                }),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                _locationManager.getCurrentLocation();
              },
              child: const Icon(Icons.location_searching),
              backgroundColor: Colors.blue,
            ),
          ),
          Positioned(
            bottom: 80,
            right: 20,
            child: FloatingActionButton(
              onPressed: _addToFavorites,
              child: const Icon(Icons.favorite, color: Colors.red),
              backgroundColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

void _addToFavorites() {
  final NavigationController? controller = Get.find<NavigationController>();

  if (controller == null) {
    print("❌ NavigationController non trouvé");
    return;
  }

  print("📍 selectedLocation: ${controller.selectedLocation.value}");
  print("🏷 selectedPlaceName: ${controller.selectedPlaceName.value}");

  if (controller.selectedLocation.value != null && controller.selectedPlaceName.value != null) {
    favoritesController.addFavorite(
      controller.selectedPlaceName.value!,
      controller.selectedLocation.value!,
    );
    Get.snackbar("Ajouté", "${controller.selectedPlaceName.value} a été ajouté aux favoris",
        snackPosition: SnackPosition.BOTTOM);
  } else {
    Get.snackbar("Erreur", "Aucune destination sélectionnée", snackPosition: SnackPosition.BOTTOM);
  }
}


  // Zoom to a specific location on the map
  void _zoomToLocation(LatLng targetLocation, String? placeName) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _markers.clear();
        _markers.add(
          flutterMap.Marker(
            point: targetLocation,
            width: 60,
            height: 60,
            child: const Icon(
              Icons.location_pin,
              size: 30,
              color: Colors.red,
            ),
          ),
        );
        _currentPlaceName = placeName ?? "Lieu inconnu";
      });

      _mapController.move(targetLocation, 15);
    });
  }

  flutterMap.TileLayer get openStreetMapTileLayer => flutterMap.TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'dev.fleaflet.flutter_map.example',
      );
}

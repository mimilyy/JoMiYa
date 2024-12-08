import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutterMap;
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import '../../services/routing/itineraire_manager.dart';

class SearchManager extends StatefulWidget {
  final flutterMap.MapController mapController; // Le contrôleur de la carte
  final List<flutterMap.Marker> markers; // Liste de marqueurs pour la carte

  SearchManager({Key? key, required this.mapController, required this.markers}) : super(key: key);
  static SearchManagerState? of(BuildContext context) {
    return context.findAncestorStateOfType<SearchManagerState>();
  }

  @override
  SearchManagerState createState() => SearchManagerState();
}

class SearchManagerState extends State<SearchManager> {
  TextEditingController _searchController = TextEditingController();
  List<String> _recentSearches = []; // Liste pour stocker les recherches récentes
  bool _showRecentSearches = true; // Contrôle l'affichage des recherches récentes

  @override
  void initState() {
    super.initState();
    _loadRecentSearches(); // Charger les recherches au démarrage
  }

  Future<void> _loadRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches = prefs.getStringList('recent_searches') ?? [];
    });
  }

  Future<void> _saveRecentSearch(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _recentSearches.insert(0, query);
    _recentSearches=_recentSearches.toSet().toList(); // Permet de ne pas afficher un doublon de recherche

    if (_recentSearches.length > 2) {
      _recentSearches = _recentSearches.sublist(0, 2);
    }
    await prefs.setStringList('recent_searches', _recentSearches);
  }

  Future<LatLng?> _searchLocation(String query) async {
    final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.isNotEmpty) {
        final lat = double.parse(data[0]['lat']);
        final lon = double.parse(data[0]['lon']);
        return LatLng(lat, lon);
      }
    }
    return null;
  }



// Dans _zoomToLocation
  void _zoomToLocation(LatLng targetLocation) {
    setState(() {
      widget.markers.clear();
      widget.markers.add(
        flutterMap.Marker(
          point: targetLocation,
          width: 60,
          height: 60,
          child: GestureDetector(
            /* // Quand je tape ça montre les itineraires options
            onTap: () {
              ItineraireManager.showItineraireOptions(context, targetLocation);
            },*/
            child: const Icon(
              Icons.location_pin,
              size: 30,
              color: Colors.red,
            ),
          ),
        ),
      );
    });
    widget.mapController.move(targetLocation, 15);
  }


  void _triggerSearch(String query) async {
    final location = await _searchLocation(query);
    if (location != null) {
      _zoomToLocation(location);
      _saveRecentSearch(query); // Sauvegarder la recherche
      setState(() {
        _showRecentSearches = true; // Afficher les recherches après une nouvelle recherche
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lieu non trouvé')),
      );
    }
  }

  void hideRecentSearches() {
    setState(() {
      _showRecentSearches = false; // Masquer les recherches récentes
    });
  }
  // Méthode pour afficher les recherches récentes
  void showRecentSearches() {
    setState(() {
      _showRecentSearches = true;  // Met à jour la variable d'état
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Barre de recherche
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Entrez un lieu ou une adresse',
                  ),
                  onSubmitted: (value) {
                    _triggerSearch(value); // Recherche au clavier (entrée)
                  },
                  onTap: () {
                    setState(() {
                      _showRecentSearches = true; // Afficher les recherches récentes lorsqu'on tape dans la barre de recherche
                    });
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => _triggerSearch(_searchController.text),
              ),
            ],
          ),
        ),
        // Affichage des dernières recherches
        if (_recentSearches.isNotEmpty && _showRecentSearches)
          Column(
            children: _recentSearches.map((search) {
              return ListTile(
                title: Text(search),
                onTap: () {
                  _searchController.text = search;
                  _triggerSearch(search);
                },
              );
            }).toList(),
          ),
      ],
    );
  }
}
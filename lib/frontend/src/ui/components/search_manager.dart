import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutterMap;
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchManager extends StatefulWidget {
  final flutterMap.MapController mapController;
  final List<flutterMap.Marker> markers;
  final void Function(LatLng, String?) onLocationSelected;

  SearchManager({
    required this.mapController,
    required this.markers,
    required this.onLocationSelected,
  });

  @override
  SearchManagerState createState() => SearchManagerState();
}

class SearchManagerState extends State<SearchManager> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _recentSearches = [];
  bool _showRecentSearches = true;
  Set<String> _favoriteDestinations = {};

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
    _loadFavorites();
  }

  Future<void> _loadRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches = prefs.getStringList('recent_searches') ?? [];
    });
  }

  Future<void> _loadFavorites() async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('favorites').get();
      setState(() {
        _favoriteDestinations = snapshot.docs.map((doc) => doc['name'] as String).toSet();
      });
    } catch (e) {
      print("Erreur lors du chargement des favoris: $e");
    }
  }

  Future<void> _saveRecentSearch(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _recentSearches.insert(0, query);
    _recentSearches = _recentSearches.toSet().toList(); // Supprime les doublons

    if (_recentSearches.length > 5) {
      _recentSearches = _recentSearches.sublist(0, 5); // Garde seulement 5 recherches max
    }
    await prefs.setStringList('recent_searches', _recentSearches);
  }

  Future<Map<String, dynamic>?> _searchLocation(String query) async {
    final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        final result = data[0];
        final lat = double.parse(result['lat']);
        final lon = double.parse(result['lon']);
        final displayName = result['display_name']; // ✅ Récupère le vrai nom du lieu
        return {
          "location": LatLng(lat, lon),
          "name": displayName,
        };
      }
    }
    return null;
  }

  void _toggleFavorite(String destination) async {
    final docRef = FirebaseFirestore.instance.collection('favorites').doc(destination);

    if (_favoriteDestinations.contains(destination)) {
      await docRef.delete();
      setState(() {
        _favoriteDestinations.remove(destination);
      });
    } else {
      await docRef.set({'name': destination});
      setState(() {
        _favoriteDestinations.add(destination);
      });
    }
  }

  void _zoomToLocation(LatLng targetLocation) {
    setState(() {
      widget.markers.clear();
      widget.markers.add(
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
    });
    widget.mapController.move(targetLocation, 15);
  }

  void triggerSearch(String query) async {
    final result = await _searchLocation(query);
    if (result != null) {
      LatLng location = result["location"];
      String placeName = result["name"]; // ✅ Utiliser le vrai nom du lieu

      _zoomToLocation(location);
      _saveRecentSearch(placeName);

      widget.onLocationSelected(location, placeName); // ✅ Correction ici

      setState(() {
        _showRecentSearches = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lieu non trouvé')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                    triggerSearch(value);
                  },
                  onTap: () {
                    setState(() {
                      _showRecentSearches = true;
                    });
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => triggerSearch(_searchController.text),
              ),
            ],
          ),
        ),
        if (_recentSearches.isNotEmpty && _showRecentSearches)
          Column(
            children: _recentSearches.map((search) {
              return ListTile(
                title: Text(search),
                onTap: () {
                  _searchController.text = search;
                  triggerSearch(search);
                },
                trailing: IconButton(
                  icon: Icon(
                    _favoriteDestinations.contains(search) ? Icons.star : Icons.star_border,
                    color: _favoriteDestinations.contains(search) ? Colors.yellow : Colors.grey,
                  ),
                  onPressed: () => _toggleFavorite(search),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}

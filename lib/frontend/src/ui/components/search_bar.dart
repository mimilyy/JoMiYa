import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart'; // Pour convertir l'adresse en coordonnées
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchBar extends StatefulWidget {
  final Function(LatLng) onLocationSelected;

  const SearchBar({super.key, required this.onLocationSelected});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  List<String> _suggestions = []; // Liste des suggestions
  bool _showSuggestions = false; // Contrôle l'affichage des suggestions

  Future<void> _searchLocation() async {
    String query = _controller.text;
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Utilisation de la bibliothèque Geocoding pour obtenir les coordonnées d'une adresse
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        LatLng targetLatLng = LatLng(locations[0].latitude, locations[0].longitude);
        widget.onLocationSelected(targetLatLng); // Transmet les coordonnées au fichier main
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lieu non trouvé')),
      );
    } finally {
      setState(() {
        _isLoading = false;
        _showSuggestions = false; // Masquer les suggestions après la recherche
      });
    }
  }

  Future<void> _getSuggestions(String query) async {
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false; // Ne pas afficher les suggestions si la requête est vide
      });
      return;
    }

    final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=5');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _suggestions = data.map((item) => item['display_name'] as String).toList();
        _showSuggestions = _suggestions.isNotEmpty; // Afficher les suggestions seulement si non vide
      });
    } else {
      setState(() {
        _suggestions = [];
        _showSuggestions = false; // Ne pas afficher les suggestions
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  onChanged: (value) {
                    _getSuggestions(value); // Appel pour récupérer les suggestions
                  },
                  decoration: const InputDecoration(
                    hintText: 'Rechercher un lieu',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: _isLoading ? const CircularProgressIndicator() : const Icon(Icons.search),
                onPressed: _isLoading ? null : _searchLocation,
              ),
            ],
          ),
          // Affichage des suggestions
          if (_showSuggestions && _suggestions.isNotEmpty)
            Container(
              color: Colors.white,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_suggestions[index]),
                    onTap: () {
                      _controller.text = _suggestions[index]; // Remplit la barre de recherche
                      _searchLocation(); // Lance la recherche
                    },
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
              ),
            ),
        ],
      ),
    );
  }
}
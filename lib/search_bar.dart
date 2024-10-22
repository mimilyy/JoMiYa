import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart'; // Pour convert the address into coordinate
import 'package:latlong2/latlong.dart';

class SearchBar extends StatefulWidget {
  final Function(LatLng) onLocationSelected;

  const SearchBar({Key? key, required this.onLocationSelected}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

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
        widget.onLocationSelected(targetLatLng); // Transmet les coordonnees au fichier main
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lieu non trouvé')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
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
    );
  }
}

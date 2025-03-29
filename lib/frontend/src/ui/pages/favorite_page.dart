import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jomiya_projet/frontend/src/services/VoyagerScreen.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:jomiya_projet/frontend/src/ui/pages/navigation_menu.dart';
import 'package:jomiya_projet/frontend/src/ui/pages/favorites_controller.dart';

class FavoritesScreen extends StatelessWidget {
  final Function(LatLng, String) onFavoriteSelected;
  final List<Map<String, dynamic>> favorites;

  const FavoritesScreen({
    super.key,
    required this.onFavoriteSelected,
    required this.favorites,
  });

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      return Scaffold(
        appBar: AppBar(title: Text('Destinations Favorites')),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection('favorites')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('Aucune destination favorite.'));
            }

            var favorites = snapshot.data!.docs;

            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                var fav = favorites[index];
                var favData = fav.data() as Map<String, dynamic>;

                String placeName = favData['name'] ?? 'Lieu inconnu';
                double? lat = favData['latitude']?.toDouble();
                double? lon = favData['longitude']?.toDouble();

                if (lat == null || lon == null) {
                  return ListTile(
                    title: Text(placeName),
                    subtitle: Text('Coordonnées non disponibles'),
                    leading: Icon(Icons.error, color: Colors.red),
                  );
                }

                LatLng location = LatLng(lat, lon);

                return ListTile(
                  title: Text(placeName),
                  onTap: () {
                    final controller = Get.find<NavigationController>();
                    controller.selectedLocation.value = location;
                    controller.selectedPlaceName.value = placeName;
                    controller.selectedIndex.value = 0;
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_on, color: Colors.blue),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          bool confirmDelete = await _showDeleteConfirmationDialog(context);
                          if (confirmDelete) {
                            final favoritesController = Get.find<FavoritesController>();
                            favoritesController.removeFavorite(fav.id);
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      );
    } else {
      final FavoritesController favoritesController = Get.find<FavoritesController>();
      return Scaffold(
        appBar: AppBar(title: Text('Destinations Favorites')),
        body: Obx(() {
          return favoritesController.favorites.isEmpty
              ? Center(child: Text('Aucune destination favorite.'))
              : ListView.builder(
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    var fav = favorites[index];
                    String placeName = fav['name'] ?? 'Lieu inconnu';
                    LatLng location = LatLng(fav['latitude'], fav['longitude']);

                    return ListTile(
                      title: Text(placeName),
                      onTap: () {
                        onFavoriteSelected(location, placeName);
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_on, color: Colors.blue),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              bool confirmDelete = await _showDeleteConfirmationDialog(context);
                              if (confirmDelete) {
                                favoritesController.favorites.removeAt(index);
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  });
        }),
      );
    }
  }
}

Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
  return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Supprimer la destination ?"),
            content: Text("Voulez-vous vraiment supprimer cette destination de vos favoris ?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("Annuler"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text("Supprimer", style: TextStyle(color: Colors.red)),
              ),
            ],
          );
        },
      ) ??
      false;
}
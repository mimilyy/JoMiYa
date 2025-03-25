import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesController extends GetxController {
  var favorites = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadFavorites();
  }

  void removeFavorite(String favoriteId) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentReference userRef = FirebaseFirestore.instance.collection('Users').doc(user.uid);
      
      // Delete the favorite from Firestore
      await userRef.collection('favorites').doc(favoriteId).delete();
      
      // Reload favorites
      _loadFavorites();
    } else {
      // Remove from local list (if user is not logged in)
      favorites.removeWhere((fav) => fav['id'] == favoriteId);
    }
  }

  void _loadFavorites() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentReference userRef = FirebaseFirestore.instance.collection('Users').doc(user.uid);
      QuerySnapshot favoritesSnapshot = await userRef.collection('favorites').get();

      favorites.assignAll(favoritesSnapshot.docs.map((doc) {
        return {
          'name': doc['name'],
          'latitude': doc['latitude'],
          'longitude': doc['longitude'],
        };
      }).toList());
    }
  }

  void addFavorite(String name, LatLng location) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentReference userRef = FirebaseFirestore.instance.collection('Users').doc(user.uid);
      await userRef.collection('favorites').add({
        'name': name,
        'latitude': location.latitude,
        'longitude': location.longitude,
      });

      _loadFavorites(); // Recharge la liste après ajout
    } else {
      favorites.add({
        'name': name,
        'latitude': location.latitude,
        'longitude': location.longitude,
      });
    }
  }
}

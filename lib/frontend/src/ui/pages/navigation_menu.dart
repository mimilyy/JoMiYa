import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:jomiya_projet/frontend/src/ui/pages/favorite_page.dart';
import 'package:jomiya_projet/frontend/src/ui/pages/favorites_controller.dart';
import 'profile/profile.dart';
import '../../services/VoyagerScreen.dart';
import 'package:latlong2/latlong.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) {
            controller.selectedIndex.value = index;
          },
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Voyager'),
            NavigationDestination(icon: Icon(Iconsax.heart), label: 'Favoris'),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'Profil'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}




class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  // Store selected favorite location
    var selectedLocation = Rxn<LatLng>();  // Permet d'avoir une valeur null
    var selectedPlaceName = Rxn<String>(); 

  final List<Map<String, dynamic>> favorites = []; // Add your favorites list here

  // Define the onFavoriteSelected callback
  void onFavoriteSelected(LatLng location, String placeName) {
    selectedLocation.value = location;
    selectedPlaceName.value = placeName;
    selectedIndex.value = 0; // Navigate to VoyagerScreen
  }

  final screens = [
    VoyagerScreen(),
    // Pass the favorites list to FavoritesScreen
  FavoritesScreen(
    onFavoriteSelected: (LatLng location, String placeName) {
      Get.find<NavigationController>().onFavoriteSelected(location, placeName);
    },
    favorites: Get.find<FavoritesController>().favorites,

  ),
    ProfileScreen(),
  ];
}

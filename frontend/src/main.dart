import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutterMap;
import 'package:latlong2/latlong.dart';
import 'ui/components/search_manager.dart'; // Importer le fichier de gestion de recherche
import 'services/routing/itineraire_manager.dart'; // Importer le fichier de gestion de la localisation
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'services/location_manager.dart';
import '../src/utils/theme/theme.dart';
import 'ui/pages/navigation_menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return MaterialApp(
      theme: isDarkMode ? TAppTheme.darkTheme : TAppTheme.lightTheme,
      home: NavigationMenu(),
      //home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
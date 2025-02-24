import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutterMap;
import 'package:get/get.dart';
import 'package:jomiya_projet/authentication/repository/authentication_repository.dart';
import 'package:jomiya_projet/firebase_options.dart';
import 'package:latlong2/latlong.dart';
import 'ui/components/search_manager.dart'; // Importer le fichier de gestion de recherche
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'services/location_manager.dart';
import 'services/routing/itineraire_manager.dart';
import 'ui/pages/navigation_menu.dart';
import 'utils/theme/theme.dart';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jomiya_projet/authentication/repository/authentication_repository.dart';
import 'package:jomiya_projet/authentication/screens/welcome_screen/welcome_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomiya_projet/authentication/repository/authentication_repository.dart';
import 'package:jomiya_projet/firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Ensure GetX navigation is properly initialized
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return GetMaterialApp(
      theme: isDarkMode ? TAppTheme.darkTheme : TAppTheme.lightTheme,
      home: const WelcomeScreen(), //écran initial
      debugShowCheckedModeBanner: false,

      //ajouts pour FireBase initialement
      initialRoute: '/', // ✅ Définir la route initiale
      getPages: [
        GetPage(name: '/', page: () => const NavigationMenu()),
        GetPage(name: '/', page: () => const NavigationMenu()),
        // Ajoutez ici d'autres pages si nécessaire
      ],
      initialBinding: BindingsBuilder(() {
        Get.put(AuthenticationRepository()); // ✅ Initialisation propre de GetX
      }),
    );
  }
}
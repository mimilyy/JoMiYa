import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomiya_projet/authentication/repository/authentication_repository.dart';
import 'package:jomiya_projet/firebase_options.dart';
import 'ui/pages/navigation_menu.dart';
import 'utils/theme/theme.dart';
import 'package:jomiya_projet/authentication/screens/welcome_screen/welcome_screen.dart';
import 'package:jomiya_projet/authentication/controllers/signup_controller.dart';


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
      initialBinding: BindingsBuilder(() {
        Get.put(AuthenticationRepository()); // ✅ Initialisation propre de GetX
        Get.put(SignUpController()); // ✅ Ajout ici pour éviter l'erreur
      }),
      initialRoute: '/1', // ✅ Définir la route initiale
      getPages: [
        GetPage(name: '/', page: () => const WelcomeScreen()), //aller voir dans auth repo pour réactiver
        GetPage(name: '/1', page: () => const NavigationMenu()),
        // Ajoutez ici d'autres pages si nécessaire
      ],

    );
  }
}
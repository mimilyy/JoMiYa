import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomiya_projet/frontend/src/ui/pages/navigation_menu.dart';
import '../signin/signin_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("JoMiYa Corporation")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Affichage du logo en haut du texte
            Image.asset(
              'assets/images/Logo.png',  // Assurez-vous que le logo est bien dans ce chemin
              width: 120, // Taille du logo (ajustez à votre convenance)
            ),
            const SizedBox(height: 20),

            // Texte principal
            const Text(
              "Votre compagnon de voyage confortable",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Bouton pour aller vers NavigationMenu (Ne pas se connecter)
            SizedBox(
              width: 250, // Largeur fixe pour les boutons
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFFF7643), width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextButton(
                  onPressed: () {
                    Get.to(() => const NavigationMenu());
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Color(0xFFFF7643), // Couleur du texte
                    backgroundColor: const Color(0xFFF5F6F9), // Fond clair
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    "Ne pas se connecter",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Bouton pour aller vers SignupScreen (Se connecter)
            SizedBox(
              width: 250, // Même largeur que le bouton précédent
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFFF7643), width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextButton(
                  onPressed: () {
                    Get.to(() => const SignInScreen());
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Color(0xFFFF7643), // Couleur du texte
                    backgroundColor: const Color(0xFFF5F6F9), // Fond clair
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    "Se connecter",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';  // Importation de GetX
import 'components/profile_menu.dart';
import 'components/profile_pic.dart';
import 'userProfile/complete_profile_screen.dart';  // Assure-toi d'importer ton fichier d'écran

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const ProfilePic(),
            const SizedBox(height: 20),
            ProfileMenu(
              text: "Mon compte",
              icon: "assets/icons/User Icon.svg",
              press: () {
                // Utilisation de GetX pour naviguer vers CompleteProfileScreen
                Get.to(() => const CompleteProfileScreen());
              },
            ),
            ProfileMenu(
              text: "Notifications",
              icon: "assets/icons/Bell.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Paramètres",
              icon: "assets/icons/Settings.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Aide",
              icon: "assets/icons/Question mark.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Se déconnecter",
              icon: "assets/icons/Log out.svg",
              press: () {},
            ),
          ],
        ),
      ),
    );
  }
}

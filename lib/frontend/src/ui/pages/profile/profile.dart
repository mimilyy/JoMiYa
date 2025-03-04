import 'package:flutter/material.dart';
import 'components/profile_menu.dart';
import 'components/profile_pic.dart';
import 'components/monCompteScreen.dart';

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
              icon: Icon(Icons.account_circle),  // Icône Flutter
              press: () {
                // Utilisation de la navigation pour aller vers MonCompteScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MonCompteScreen()),
                );
              },
            ),
            ProfileMenu(
              text: "Notifications",
              icon: Icon(Icons.notifications),  // Icône Flutter
              press: () {} ,
            ),
            ProfileMenu(
              text: "Paramètres",
              icon: Icon(Icons.settings),  // Icône Flutter
              press: () {} ,
            ),
            ProfileMenu(
              text: "Aide",
              icon: Icon(Icons.help),  // Icône Flutter
              press: () {} ,
            ),
            ProfileMenu(
              text: "Se déconnecter",
              icon: Icon(Icons.logout),  // Icône Flutter
              press: () {} ,
            ),
          ],
        ),
      ),
    );
  }
}
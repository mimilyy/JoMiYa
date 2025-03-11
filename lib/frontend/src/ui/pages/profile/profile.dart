import 'package:flutter/material.dart';
import 'package:jomiya_projet/frontend/src/ui/pages/profile/components/account_managment/account_managment_screen.dart';
import 'components/preferences/profile_menu.dart';
import 'components/preferences/profile_pic.dart';
import 'components/preferences/monCompteScreen.dart';
import 'package:jomiya_projet/authentication/screens/signup/widgets/signup_screen.dart';
import 'package:jomiya_projet/authentication/screens/signin/signin_screen.dart';

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
                  MaterialPageRoute(builder: (context) => const AccountManagementScreen()), 
                );
              },
            ),

            ProfileMenu(
              text: "Préférences",
              icon: Icon(Icons.favorite),  // Icône Flutter
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


            /*
            ProfileMenu(
              text: "Se connecter",
              icon: Icon(Icons.login),
              press: () {
                // Utilisation de la navigation pour aller vers signup_screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                );
              },
            ),
            ProfileMenu(
              text: "Se déconnecter",
              icon: Icon(Icons.logout),  // Icône Flutter
              press: () {} ,
            ),
           */
          ],
        ),
      ),
    );
  }
}
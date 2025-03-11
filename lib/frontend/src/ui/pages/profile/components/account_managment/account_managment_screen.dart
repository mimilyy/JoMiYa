import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jomiya_projet/authentication/screens/signin/signin_screen.dart';
import 'package:jomiya_projet/authentication/screens/signup/widgets/signup_screen.dart';
import 'package:jomiya_projet/frontend/src/ui/pages/profile/components/account_managment/account_manager_screen.dart'; // Importation de la nouvelle page
import '../preferences/profile_menu.dart';  // Ajouter ce import
import '../preferences/profile_pic.dart';   // Ajouter ce import

class AccountManagementScreen extends StatelessWidget {
  const AccountManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestion du compte"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const ProfilePic(), // Photo de profil (similaire à l'original)
            const SizedBox(height: 20),

            // Affichage du statut de connexion
            Text(
              user != null
                  ? "Connecté(e) en tant que ${user.email}"
                  : "Vous n'êtes pas connecté(e)",
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Affichage des options sous forme de menu (comme dans ProfileScreen)
            if (user == null) ...[
              ProfileMenu(
                text: "Se connecter",
                icon: const Icon(Icons.login),
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignInScreen()),
                  );
                },
              ),
              const SizedBox(height: 10),
              ProfileMenu(
                text: "Créer un compte",
                icon: const Icon(Icons.person_add),
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignUpScreen()),
                  );
                },
              ),
            ] else ...[
              ProfileMenu(
                text: "Gérer mon compte",
                icon: const Icon(Icons.manage_accounts),
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AccountManagerScreen()),
                  );
                },
              ),
              const SizedBox(height: 10),
              ProfileMenu(
                text: "Se déconnecter",
                icon: const Icon(Icons.logout),
                press: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Déconnecté avec succès")),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jomiya_projet/authentication/screens/signin/signin_screen.dart';
import 'package:jomiya_projet/authentication/screens/signup/widgets/signup_screen.dart';

class AccountManagementScreen extends StatelessWidget {
  const AccountManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestion du compte"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.account_circle, size: 100, color: Colors.grey),
            const SizedBox(height: 20),

            // Affichage du statut de connexion
            Text(
              user != null
                  ? "Connecté en tant que ${user.email}"
                  : "Vous n'êtes pas connecté",
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Si l'utilisateur est déconnecté
            if (user == null) ...[
              ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text("Se connecter"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignInScreen()),
                  );
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.person_add),
                label: const Text("Créer un compte"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignUpScreen()),
                  );
                },
              ),
            ]
            // Si l'utilisateur est connecté
            else ...[
              ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text("Se déconnecter"),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut(); //possibilité d'utiliser la fonction définie dans le repo aussi
                  Navigator.pop(context); // Retour à l'écran précédent
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

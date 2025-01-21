import 'package:flutter/material.dart';
import 'create_profile_page.dart';
import 'login_page.dart'; // Page vide pour le moment

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                // Naviguer vers la page de création de profil
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateProfilePage()),
                );
              },
              child: Text('Créer un profil'),
            ),
            SizedBox(height: 10), // Espacement entre les boutons
            ElevatedButton(
              onPressed: () {
                // Naviguer vers une page de connexion vide
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Se connecter'),
            ),
          ],
        ),
      ),
    );
  }
}

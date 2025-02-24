import 'package:flutter/material.dart';
import 'package:jomiya_projet/backend/database/models/database_helper.dart';

class CreateProfilePage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController(); //TextEditingController permet de recuperer du texte
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Créer un Profil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nom'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20), //Le code jusqu'ici créer l'interface utilisateur, la suite du code créer la logique
            ElevatedButton(
              onPressed: () async {
                String name = nameController.text;
                String email = emailController.text;

                if (name.isNotEmpty && email.isNotEmpty) {
                  try {
                    // Insert into database
                    final dbHelper = DatabaseHelper();
                    await dbHelper.insertProfile({
                      'name': name,
                      'email': email,
                    });

                    // Affiche un message de succès
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Profil créé avec succès!')),
                    );

                    // Retourne à la page précédente (les paramètres)
                    Navigator.pop(context); // Ferme la page actuelle
                  } catch (e) {
                    // Gérer les erreurs (ex : email déjà utilisé)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur : ${e.toString()}')),
                    );
                  }
                } else {
                  // Affiche un message d'erreur si les champs sont vides
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Veuillez remplir tous les champs.')),
                  );
                }
              },
              child: Text('Créer'),
            ),
          ],
        ),
      ),
    );
  }
}

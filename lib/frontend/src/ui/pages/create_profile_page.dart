import 'package:flutter/material.dart';
import 'package:jomiya_projet/backend/database/models/database_helper.dart';

class CreateProfilePage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String name = nameController.text;
                String email = emailController.text;

                if (name.isNotEmpty && email.isNotEmpty) {
                  // Insert into database
                  final dbHelper = DatabaseHelper();
                  await dbHelper.insertProfile({
                    'name': name,
                    'email': email,
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Profil créé avec succès!')),
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

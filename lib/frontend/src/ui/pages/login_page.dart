import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion'),
      ),
      body: Center(
        child: Text(
          'Page de connexion (à venir)',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}

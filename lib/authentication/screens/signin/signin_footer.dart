import 'package:flutter/material.dart';
import 'package:jomiya_projet/authentication/screens/signup/widgets/signup_screen.dart';

class SignInFooter extends StatelessWidget {
  const SignInFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Vous n'avez pas de compte ?"),
        TextButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignUpScreen()),
          );
        },
          child: const Text("S'inscrire"),
        ),
      ],
    );
  }
}
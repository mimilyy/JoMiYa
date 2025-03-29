import 'package:flutter/material.dart';
import 'package:jomiya_projet/authentication/screens/signin/signin_screen.dart';

class SignUpFooter extends StatelessWidget {
  const SignUpFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Vous avez déjà un compte ?"),
        TextButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignInScreen()),
          );
        },
          child: const Text("Se connecter"),
        ),
      ],
    );
  }
}

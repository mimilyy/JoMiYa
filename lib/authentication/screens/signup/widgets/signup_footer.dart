import 'package:flutter/material.dart';

class SignUpFooter extends StatelessWidget {
  const SignUpFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Vous avez déjà un compte ?"),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Se connecter"),
        ),
      ],
    );
  }
}

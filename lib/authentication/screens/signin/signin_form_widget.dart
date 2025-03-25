import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/signin_controller.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignInController>();

    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Connexion",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Champ Email
          TextFormField(
            controller: controller.emailController,
            decoration: const InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) =>
            value == null || value.isEmpty ? "Veuillez entrer un email" : null,
          ),
          const SizedBox(height: 10),

          // Champ Mot de passe
          TextFormField(
            controller: controller.passwordController,
            decoration: const InputDecoration(
              labelText: "Mot de passe",
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            validator: (value) =>
            value == null || value.length < 6 ? "Le mot de passe doit contenir au moins 6 caractères" : null,
          ),
          const SizedBox(height: 20),

          // Bouton "Se connecter" avec le même style que "S'inscrire"
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFFF7643), width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextButton(
                onPressed: () {
                  if (controller.formKey.currentState!.validate()) {
                    controller.signIn(); // Logique de connexion
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: Color(0xFFFF7643), // Couleur du texte
                  backgroundColor: const Color(0xFFF5F6F9), // Fond clair
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Se connecter",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
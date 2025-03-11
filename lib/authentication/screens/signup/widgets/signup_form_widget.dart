import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/signup_controller.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignUpController>(); // Ne pas recréer l'instance, cherche celle existante

    return Form(
      key: controller.formKey, // Utilise une clé globale définie dans SignUpController pour gérer la validation
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Créer un compte",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Champ nom d'utilisateur
          TextFormField(
            controller: controller.usernameController,
            decoration: const InputDecoration(
              labelText: "Nom d'utilisateur",
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
            value == null || value.isEmpty ? "Veuillez entrer un nom d'utilisateur" : null,
          ),
          const SizedBox(height: 10),

          // Champ email
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

          // Champ mot de passe
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
          const SizedBox(height: 10),

          // Champ confirmer le mot de passe
          TextFormField(
            controller: controller.confirmPasswordController,
            decoration: const InputDecoration(
              labelText: "Confirmer le mot de passe",
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            validator: (value) =>
            value == null || value != controller.passwordController.text ? "Les mots de passe ne correspondent pas" : null,
          ),
          const SizedBox(height: 20),

          // Bouton "S'inscrire" avec style et couleurs
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
                    // Logique d'inscription
                    controller.createUser();
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: Color(0xFFFF7643), // Couleur du texte
                  backgroundColor: const Color(0xFFF5F6F9), // Fond clair
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "S'inscrire",
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
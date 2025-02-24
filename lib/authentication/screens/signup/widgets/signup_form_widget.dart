import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/signup_controller.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignUpController>(); // ✅ Correction ici pour éviter de recréer l'instance

    return Form(
      key: controller.formKey, 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Créer un compte",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
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
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.signUp, 
              child: const Text("S'inscrire"),
            ),
          ),
        ],
      ),
    );
  }
}

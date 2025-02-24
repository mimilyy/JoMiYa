import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/signup_controller.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());

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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Veuillez entrer un nom d'utilisateur";
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: controller.emailController,
            decoration: const InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Veuillez entrer un email";
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: controller.passwordController,
            decoration: const InputDecoration(
              labelText: "Mot de passe",
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.length < 6) {
                return "Le mot de passe doit contenir au moins 6 caractères";
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: controller.confirmPasswordController,
            decoration: const InputDecoration(
              labelText: "Confirmer le mot de passe",
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value != controller.passwordController.text) {
                return "Les mots de passe ne correspondent pas";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (controller.formKey.currentState!.validate()) {
                  controller.signUp();
                }
              },
              child: const Text("S'inscrire"),
            ),
          ),
        ],
      ),
    );
  }
}

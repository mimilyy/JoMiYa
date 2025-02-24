import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomiya_projet/frontend/src/ui/pages/navigation_menu.dart';
import '../signup/widgets/signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Welcome")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to the App!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Bouton pour aller vers NavigationMenu
            ElevatedButton(
              onPressed: () {
                Get.to(() => const NavigationMenu());
              },
              child: const Text("Go to Navigation Menu"),
            ),
            const SizedBox(height: 20),

            // Bouton pour aller vers SignupScreen
            ElevatedButton(
              onPressed: () {
                Get.to(() => const SignUpScreen());
              },
              child: const Text("Go to Signup"),
            ),
          ],
        ),
      ),
    );
  }
}

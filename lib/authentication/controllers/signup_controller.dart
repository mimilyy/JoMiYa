import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomiya_projet/frontend/src/ui/pages/navigation_menu.dart';

class SignUpController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void signUp() {
    if (formKey.currentState!.validate()) {
      String username = usernameController.text.trim();
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      
      debugPrint("Inscription réussie pour : $username, $email");

      // Redirection vers la page NavigationMenu après l'inscription réussie
      Get.offAll(() => const NavigationMenu());

    }
  }
}

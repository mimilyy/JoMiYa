import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomiya_projet/authentication/repository/authentication_repository.dart';
import 'package:jomiya_projet/frontend/src/ui/pages/navigation_menu.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

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

  void signUp() async {
    if (!formKey.currentState!.validate()) return; // ✅ Vérifie d'abord si le formulaire est valide

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      await AuthenticationRepository.instance.createUserWithEmailAndPassword(email, password);
      Get.offAll(() => const NavigationMenu()); // ✅ Redirige vers NavigationMenu après inscription
    } catch (e) {
      Get.snackbar("Erreur d'inscription", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }
}

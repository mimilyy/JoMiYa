import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomiya_projet/authentication/repository/authentication_repository/authentication_repository.dart';
import 'package:jomiya_projet/frontend/src/ui/pages/navigation_menu.dart';

class SignInController extends GetxController {
  static SignInController get instance => Get.find();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  final formKey = GlobalKey<FormState>(); 

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void signIn() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      await AuthenticationRepository.instance.loginWithEmailAndPassword(email, password);
      //Get.offAll(() => const NavigationMenu()); //déjà dans le repo
    } catch (e) {
      Get.snackbar("Erreur de connexion", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }
}
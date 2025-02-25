import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomiya_projet/authentication/models/user_model.dart';
import 'package:jomiya_projet/authentication/repository/authentication_repository/authentication_repository.dart';
import 'package:jomiya_projet/frontend/src/ui/pages/navigation_menu.dart';
import 'package:jomiya_projet/authentication/repository/user_repository/user_repository.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  //to recover the text entries
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

  void signUp() async { //faire signin et emprecher la creation de plusieurs comptes avec la même adresse email

    //Déplacé dans le form pour que l'on ne fasse le test qu'une seule fois pour plusieurs actions
    //if (!formKey.currentState!.validate()) return; // ✅ Vérifie d'abord si le formulaire est valide avec les clés
    
    String email = emailController.text.trim(); //récupère les valeurs, peut être appelé depuis signup form mais semble plus logique ici
    String password = passwordController.text.trim();

    try {
      await AuthenticationRepository.instance.createUserWithEmailAndPassword(email, password);
      Get.offAll(() => const NavigationMenu()); // ✅ Redirige vers NavigationMenu après inscription
    } catch (e) {
      Get.snackbar("Erreur d'inscription", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }




Future<void> createUser() async { 
    
  final user = UserModel(
    name: usernameController.text.trim(),
    email: emailController.text.trim(),
    password: passwordController.text.trim(),
  );

    try {
      await UserRepository.instance.createUser(user); //le point instance permet d'accéder à l'instance d'UserRopsitory géré par Getx
      await AuthenticationRepository.instance.createUserWithEmailAndPassword(user.email, user.password);
      Get.to(() => const NavigationMenu());

    } catch (e) {
      Get.snackbar("Erreur d'inscription", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }

}


}
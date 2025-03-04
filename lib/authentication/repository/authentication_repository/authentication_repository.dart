import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomiya_projet/authentication/repository/authentication_repository/exceptions/singup_email_password_failure.dart';
import 'package:jomiya_projet/frontend/src/ui/pages/profile/components/account_managment/account_managment_screen.dart';
import '../../screens/welcome_screen/welcome_screen.dart';
import '../../screens/dashboard/dashboard.dart';
import 'package:jomiya_projet/frontend/src/ui/pages/navigation_menu.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Rx<User?> to track user authentication state
  final Rx<User?> firebaseUser = Rx<User?>(null);

  @override
  void onReady() {
    super.onReady();

    // Ensure Firebase is ready before binding
    firebaseUser.value = _auth.currentUser;

    firebaseUser.bindStream(_auth.authStateChanges());


/* deactivate welcome screen

    // Delay navigation slightly to ensure Firebase is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setInitialScreen(firebaseUser.value);
    });

    ever(firebaseUser, _setInitialScreen);

    */
  }


/*
//No need if no welcome screen
  void _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => const WelcomeScreen());
    } else {
      Get.offAll(() => const NavigationMenu());
    }
  }
*/



  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signOut();
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      Get.back();
      //Get.off(() => const AccountManagementScreen());
    } on FirebaseAuthException catch (e) {
      final ex = SingUpWithEmailAndPasswordFailure.code(e.code);
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      throw ex;
    } catch (e) {
      print('Unknown error: $e');
    }
  }


Future<void> loginWithEmailAndPassword(String email, String password) async {
  try {
    await _auth.signOut(); // Déconnecte l'utilisateur avant chaque connexion

    UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);

    if (userCredential.user != null) {
      print("🔥 Connexion réussie : UID = ${userCredential.user!.uid}");
      //Get.off(() => const AccountManagementScreen());
      Get.back();
    } else {
      print("❌ Erreur : utilisateur null après authentification.");
    }
  } on FirebaseAuthException catch (e) {
    print("⚠️ FirebaseAuthException : ${e.code} - ${e.message}");
  } catch (e) {
    print("🚨 Erreur inattendue : $e");
  }
}


  Future<void> logout() async {
    await _auth.signOut();
    Get.back();
    //Get.off(() => const AccountManagementScreen()); //deactivate welcome screen
  }
}

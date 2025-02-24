import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomiya_projet/authentication/repository/exceptions/singup_email_password_failure.dart';
import '../screens/welcome_screen/welcome_screen.dart';
import '../screens/dashboard/dashboard.dart';
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



//No need if no welcome screen
  void _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => const WelcomeScreen());
    } else {
      Get.offAll(() => const NavigationMenu());
    }
  }




  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      Get.offAll(() => const NavigationMenu());
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
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.offAll(() => const NavigationMenu());
    } on FirebaseAuthException catch (e) {
      print("Login failed: ${e.message}");
    } catch (e) {
      print("An unexpected error occurred: $e");
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    //Get.offAll(() => const WelcomeScreen()); //deactivate welcome screen
  }
}

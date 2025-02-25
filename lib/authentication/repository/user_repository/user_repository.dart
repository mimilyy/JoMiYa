import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jomiya_projet/authentication/models/user_model.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// 🔹 Créer un utilisateur dans Firestore avec l'UID de Firebase Auth
  Future<void> createUser(UserModel user) async {
    try {
      await _db.collection("Users").doc(user.id).set(user.toJson());
      Get.snackbar(
        "Succès", "Votre compte a été créé avec succès",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green
      );
    } catch (error) {
      Get.snackbar(
        "Erreur", "Une erreur est survenue lors de la création du compte",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red
      );
      print(error.toString());
    }
  }

  /// 🔹 Récupérer un utilisateur avec son UID
  Future<UserModel?> getUserDetails(String uid) async {
    try {
      final snapshot = await _db.collection("Users").doc(uid).get();

      if (snapshot.exists) {
        return UserModel.fromSnapshot(snapshot);
      } else {
        return null;
      }
    } catch (error) {
      Get.snackbar(
        "Erreur", "Impossible de récupérer les données utilisateur",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red
      );
      print(error.toString());
      return null;
    }
  }

  /// 🔹 Mettre à jour les informations d'un utilisateur via son UID
  Future<void> updateUserDetails(String uid, Map<String, dynamic> updatedData) async {
    try {
      await _db.collection("Users").doc(uid).update(updatedData);
      Get.snackbar(
        "Succès", "Vos informations ont été mises à jour",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green
      );
    } catch (error) {
      Get.snackbar(
        "Erreur", "Impossible de mettre à jour les données",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red
      );
      print(error.toString());
    }
  }
}

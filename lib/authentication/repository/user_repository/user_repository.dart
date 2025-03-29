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


Future<void> saveUserPreferences(String userId, Map<String, dynamic> preferences) async {
  try {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .collection("Preferences")
        .doc("settings") // Stockage unique des préférences
        .set(preferences, SetOptions(merge: true));

    Get.snackbar("Succès", "Préférences enregistrées avec succès");
  } catch (e) {
    Get.snackbar("Erreur", "Impossible d'enregistrer les préférences");
    print("Erreur Firestore : ${e.toString()}");
  }
}


Future<Map<String, dynamic>?> loadUserPreferences(String userId) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .collection("Preferences")
        .doc("settings")
        .get();

    if (snapshot.exists) {
      return snapshot.data();
    } else {
      return null;
    }
  } catch (e) {
    Get.snackbar("Erreur", "Impossible de charger les préférences");
    print("Erreur Firestore : ${e.toString()}");
    return null;
  }
}

/*


Future<void> _loadPreferences() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    var preferences = await loadUserPreferences(user.uid);
    if (preferences != null) {
      setState(() {
        _ascenseurSelected = preferences["ascenseur"] ?? false;
        _escaliersSelected = preferences["escaliers"] ?? false;
        _escalatorDownSelected = preferences["escalatorDown"] ?? false;
        _escalatorUpSelected = preferences["escalatorUp"] ?? false;
      });
    }
  }
}



Future<void> _savePreferences() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    Map<String, dynamic> preferences = {
      "ascenseur": _ascenseurSelected,
      "escaliers": _escaliersSelected,
      "escalatorDown": _escalatorDownSelected,
      "escalatorUp": _escalatorUpSelected,
    };
    await saveUserPreferences(user.uid, preferences);
  }
}
*/

}

/*

User repository to perform databse operations with firestore


*/


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jomiya_projet/authentication/models/user_model.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createUser(UserModel user) async{
    await _db.collection("Users").add(user.toJson()) //Querry to add a user document in the User collection
    
    // Ending operators
    .whenComplete(  
      () => Get.snackbar("Succes", "Your account has been created for Firestore",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green),
      )
    .catchError((error, stackTrace){
        Get.snackbar("Error", "Something went wrong. For Firestore",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red);
        print(error.toString());
      }
      );
  }


  //Fetch the users (one or many) you want with email
  Future<UserModel> getUserDetails(String email) async {
    final snapshot = await _db.collection("Users").where("Email", isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }


}
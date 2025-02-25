


//Create a model of the data in a user document



import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  final String? id;
  final String name;
  final String email;
  final String password;

const UserModel({
  this.id,
  required this.email,
  required this.name,
  required this.password,
});

toJson(){ //firestore use this format
  return {
    "Name": name,
    "Email": email,
    "Password": password,
  };
}

//map user fetched data from Firestore to UserModel
factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
  final data = document.data()!;
  return UserModel(id: document.id, email: data["email"], password: data["password"], name: data["name"]);
}


}


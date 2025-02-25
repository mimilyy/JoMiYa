import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id; // 🔹 UID is now required
  final String name;
  final String email;
  final String password;

  const UserModel({
    required this.id, // 🔹 UID is required
    required this.email,
    required this.name,
    required this.password,
  });

  /// Convert UserModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      "id": id, // 🔹 Store UID in Firestore
      "Name": name, // 🔹 Match Firestore field name
      "Email": email,
      "Password": password,
    };
  }

  /// Convert Firestore document to UserModel
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      id: document.id, // 🔹 Ensure ID is taken from Firestore doc ID
      name: data["Name"] ?? "", // 🔹 Correct field name
      email: data["Email"] ?? "",
      password: data["Password"] ?? "",
    );
  }
}

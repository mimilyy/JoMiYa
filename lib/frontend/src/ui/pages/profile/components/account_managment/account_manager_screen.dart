import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:jomiya_projet/authentication/repository/user_repository/user_repository.dart';
// Importation de ProfileMenu
import '../preferences/profile_pic.dart';   // Importation de ProfilePic

class AccountManagerScreen extends StatefulWidget {
  const AccountManagerScreen({super.key});

  @override
  _AccountManagerScreenState createState() => _AccountManagerScreenState();
}

class _AccountManagerScreenState extends State<AccountManagerScreen> {
  final UserRepository _userRepo = UserRepository.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    User? user = _auth.currentUser;
    if (user != null) {
      var userData = await _userRepo.getUserDetails(user.uid); //uid Firebase auth
      if (userData != null) {
        setState(() {
          _nameController.text = userData.name;
        });
      }
    }
    setState(() => _isLoading = false);
  }

  Future<void> _updateUserName() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _userRepo.updateUserDetails(user.uid, {"Name": _nameController.text});
    }
  }

  Future<void> _updatePassword() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.updatePassword(_passwordController.text); //change pour firebase _auth et est plus sécurisé
      await _userRepo.updateUserDetails(user.uid, {"Password": _passwordController.text}); // Pour la DB
      Get.snackbar("Succès", "Mot de passe mis à jour");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestion du compte"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Retour à la page précédente
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const ProfilePic(), // Photo de profil
            const SizedBox(height: 20),

            // Affichage de la section de données utilisateur avec un état de chargement
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Nom",
                    filled: true,
                    fillColor: Color(0xFFF5F6F9),  // Couleur de fond neutre
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                Text("Email: ${_auth.currentUser?.email}",
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                // Bouton pour mettre à jour le nom avec un contour
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFFF7643), width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextButton(
                    onPressed: _updateUserName,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.orange, // Couleur orange
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "Mettre à jour le nom",
                      style: TextStyle(fontSize: 16), // Taille de texte plus fine
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Champ de texte pour le nouveau mot de passe
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: "Nouveau mot de passe",
                    filled: true,
                    fillColor: Color(0xFFF5F6F9),  // Couleur de fond neutre
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                // Bouton pour changer le mot de passe avec un contour
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFFF7643), width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextButton(
                    onPressed: _updatePassword,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.orange, // Couleur orange
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "Changer le mot de passe",
                      style: TextStyle(fontSize: 16), // Taille de texte plus fine
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

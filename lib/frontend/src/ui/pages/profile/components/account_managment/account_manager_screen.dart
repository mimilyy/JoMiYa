import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:jomiya_projet/authentication/repository/user_repository/user_repository.dart';

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
      await user.updatePassword(_passwordController.text); //change pour firebase _auth et est plus s&curis&
      await _userRepo.updateUserDetails(user.uid, {"Password": _passwordController.text}); // Pour la DB
      Get.snackbar("Succès", "Mot de passe mis à jour");
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Get.offAllNamed("/login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestion du compte")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: "Nom"),
                  ),
                  const SizedBox(height: 20),
                  Text("Email: ${_auth.currentUser?.email}",
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateUserName,
                    child: const Text("Mettre à jour le nom"),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: "Nouveau mot de passe"),
                    obscureText: true,
                  ),
                  ElevatedButton(
                    onPressed: _updatePassword,
                    child: const Text("Changer le mot de passe"),
                  ),
                  ElevatedButton(
                    onPressed: _logout,
                    child: const Text("Se déconnecter"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ],
              ),
            ),
    );
  }
}

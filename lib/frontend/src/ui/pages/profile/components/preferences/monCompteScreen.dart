import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'preferencesResultScreen.dart';
import '../../../../../utils/constants/constants.dart'; // Assurez-vous d'importer les constantes si vous en avez

class MonCompteScreen extends StatefulWidget {
  const MonCompteScreen({super.key});

  @override
  _MonCompteScreenState createState() => _MonCompteScreenState();
}

class _MonCompteScreenState extends State<MonCompteScreen> {
  bool _ascenseurSelected = false;
  bool _escaliersSelected = false;
  bool _escalatorDownSelected = false;
  bool _escalatorUpSelected = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadUserPreferences(); // Charger les préférences de l'utilisateur à l'ouverture de la page
  }

  /// 🔹 Charger les préférences utilisateur depuis Firestore si l'utilisateur est connecté
  Future<void> _loadUserPreferences() async {
    User? user = _auth.currentUser;
    if (user == null) return; // Si aucun utilisateur n'est connecté, ne rien faire
    try{
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection("Users")
          .doc(user.uid)
          .collection("Preferences")
          .doc("settings") // Document contenant les préférences
          .get();

      if (snapshot.exists) {
        setState(() {
          _ascenseurSelected = snapshot.data()?["ascenseur"] ?? false;
          _escaliersSelected = snapshot.data()?["escaliers"] ?? false;
          _escalatorDownSelected = snapshot.data()?["escalatorDown"] ?? false;
          _escalatorUpSelected = snapshot.data()?["escalatorUp"] ?? false;
        });
      }
    }
    catch(e){}
  }

  /// 🔹 Sauvegarder les préférences utilisateur dans Firestore
  Future<void> _saveUserPreferences() async {
    User? user = _auth.currentUser;
    if (user == null) return; // Vérifier si un utilisateur est connecté

    Map<String, dynamic> preferences = {
      "ascenseur": _ascenseurSelected,
      "escaliers": _escaliersSelected,
      "escalatorDown": _escalatorDownSelected,
      "escalatorUp": _escalatorUpSelected,
    };

    await _firestore
        .collection("Users")
        .doc(user.uid)
        .collection("Preferences")
        .doc("settings")
        .set(preferences, SetOptions(merge: true)); // Merge permet d'éviter d'écraser d'autres préférences
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Préférences de déplacement"),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Sélectionnez vos préférences de moyens de déplacement :",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Boutons de sélection des préférences
            _buildPreferenceButton(
              "Escaliers",
              "assets/images/escaliers.png",
              _escaliersSelected,
                  () => setState(() => _escaliersSelected = !_escaliersSelected),
            ),
            _buildPreferenceButton(
              "Escalier mécanique descendant",
              "assets/images/escalatordown.png",
              _escalatorDownSelected,
                  () => setState(() => _escalatorDownSelected = !_escalatorDownSelected),
            ),
            _buildPreferenceButton(
              "Escalier mécanique montant",
              "assets/images/escalatorup.png",
              _escalatorUpSelected,
                  () => setState(() => _escalatorUpSelected = !_escalatorUpSelected),
            ),
            _buildPreferenceButton(
              "Ascenseur",
              "assets/images/ascenseur.png",
              _ascenseurSelected,
                  () => setState(() => _ascenseurSelected = !_ascenseurSelected),
            ),

            const SizedBox(height: 20),

            // Nouveau bouton "Voir les résultats" avec contour et style modifié
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: kPrimaryColor, width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextButton(
                onPressed: () async {
                  await _saveUserPreferences(); // 🔹 Sauvegarder avant d'afficher les résultats
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PreferencesResultScreen(
                        preferences: _getPreferencesText(),
                        ascenseurSelected: _ascenseurSelected,
                        escaliersSelected: _escaliersSelected,
                        escalatorDownSelected: _escalatorDownSelected,
                        escalatorUpSelected: _escalatorUpSelected,
                      ),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.orange, // Couleur orange
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Voir les résultats",
                  style: TextStyle(fontSize: 16), // Taille de texte plus fine
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Retourne une chaîne de caractères listant les préférences sélectionnées
  String _getPreferencesText() {
    List<String> selectedPreferences = [];
    if (_ascenseurSelected) selectedPreferences.add("Ascenseur");
    if (_escaliersSelected) selectedPreferences.add("Escaliers");
    if (_escalatorUpSelected) selectedPreferences.add("Escalier mécanique montant");
    if (_escalatorDownSelected) selectedPreferences.add("Escalier mécanique descendant");

    return selectedPreferences.isEmpty
        ? "Aucune préférence sélectionnée."
        : "Préférences sélectionnées :\n${selectedPreferences.join("\n")}";
  }

  /// 🔹 Widget générique pour un bouton de préférence
  Widget _buildPreferenceButton(
      String title, String imagePath, bool isSelected, VoidCallback onPressed) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: kPrimaryColor,
        padding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: const Color(0xFFF5F6F9),
      ),
      onPressed: onPressed,
      child: Row(
        children: [
          Image.asset(imagePath, width: 40),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Icon(
            isSelected ? Icons.check_circle : Icons.check_circle_outline,
            color: isSelected ? kPrimaryColor : Colors.grey,
          ),
        ],
      ),
    );
  }
}
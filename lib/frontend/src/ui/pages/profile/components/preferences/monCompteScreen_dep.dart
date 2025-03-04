import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mon Compte - Préférences de Déplacement"),
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

            // Escaliers
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: kPrimaryColor,
                padding: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                backgroundColor: const Color(0xFFF5F6F9),
              ),
              onPressed: () {
                setState(() {
                  _escaliersSelected = !_escaliersSelected;
                });
              },
              child: Row(
                children: [
                  Image.asset("assets/images/escaliers.png", width: 40),
                  const SizedBox(width: 20),
                  Expanded(
                    child: const Text(
                      "Escaliers",
                      style: TextStyle(fontSize: 20), // Augmenter la taille de la police
                    ),
                  ),
                  Icon(
                    _escaliersSelected ? Icons.check_circle : Icons.check_circle_outline,
                    color: _escaliersSelected ? kPrimaryColor : Colors.grey,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Escalator Descendant
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: kPrimaryColor,
                padding: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                backgroundColor: const Color(0xFFF5F6F9),
              ),
              onPressed: () {
                setState(() {
                  _escalatorDownSelected = !_escalatorDownSelected;
                });
              },
              child: Row(
                children: [
                  Image.asset("assets/images/escalatordown.png", width: 40),
                  const SizedBox(width: 20),
                  Expanded(
                    child: const Text(
                      "Escalier mécanique descendant",
                      style: TextStyle(fontSize: 20), // Augmenter la taille de la police
                    ),
                  ),
                  Icon(
                    _escalatorDownSelected ? Icons.check_circle : Icons.check_circle_outline,
                    color: _escalatorDownSelected ? kPrimaryColor : Colors.grey,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Escalator Montant
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: kPrimaryColor,
                padding: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                backgroundColor: const Color(0xFFF5F6F9),
              ),
              onPressed: () {
                setState(() {
                  _escalatorUpSelected = !_escalatorUpSelected;
                });
              },
              child: Row(
                children: [
                  Image.asset("assets/images/escalatorup.png", width: 40),
                  const SizedBox(width: 20),
                  Expanded(
                    child: const Text(
                      "Escalier mécanique montant",
                      style: TextStyle(fontSize: 20), // Augmenter la taille de la police
                    ),
                  ),
                  Icon(
                    _escalatorUpSelected ? Icons.check_circle : Icons.check_circle_outline,
                    color: _escalatorUpSelected ? kPrimaryColor : Colors.grey,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Ascenseur
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: kPrimaryColor,
                padding: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                backgroundColor: const Color(0xFFF5F6F9),
              ),
              onPressed: () {
                setState(() {
                  _ascenseurSelected = !_ascenseurSelected;
                });
              },
              child: Row(
                children: [
                  Image.asset("assets/images/ascenseur.png", width: 40),
                  const SizedBox(width: 20),
                  Expanded(
                    child: const Text(
                      "Ascenseur",
                      style: TextStyle(fontSize: 20), // Augmenter la taille de la police
                    ),
                  ),
                  Icon(
                    _ascenseurSelected ? Icons.check_circle : Icons.check_circle_outline,
                    color: _ascenseurSelected ? kPrimaryColor : Colors.grey,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Bouton Voir les résultats avec une police plus petite
            ElevatedButton(
              onPressed: () {
                // Afficher les résultats dans un dialogue ou une nouvelle page
                String preferences = "Préférences sélectionnées :\n";
                if (_ascenseurSelected) preferences += "Ascenseur\n";
                if (_escaliersSelected) preferences += "Escaliers\n";
                if (_escalatorUpSelected) preferences += "Escalier mécanique montant\n";
                if (_escalatorDownSelected) preferences += "Escalier mécanique descendant\n";

                // Affichage des résultats
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PreferencesResultScreen(
                      preferences: preferences,
                      ascenseurSelected: _ascenseurSelected,
                      escaliersSelected: _escaliersSelected,
                      escalatorDownSelected: _escalatorDownSelected,
                      escalatorUpSelected: _escalatorUpSelected,
                    ),
                  ),
                );

              },
              style: ElevatedButton.styleFrom(
                foregroundColor: kPrimaryColor,
                backgroundColor: Color(0xFFF5F6F9),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                "Voir les résultats",
                style: TextStyle(fontSize: 14), // Police plus petite pour le bouton
              ),
            ),
          ],
        ),
      ),
    );
  }
}

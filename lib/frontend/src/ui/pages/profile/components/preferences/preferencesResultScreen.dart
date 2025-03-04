import 'package:flutter/material.dart';


class PreferencesResultScreen extends StatelessWidget {
  final String preferences;
  final bool ascenseurSelected;
  final bool escaliersSelected;
  final bool escalatorDownSelected;
  final bool escalatorUpSelected;

  const PreferencesResultScreen({
    super.key,
    required this.preferences,
    required this.ascenseurSelected,
    required this.escaliersSelected,
    required this.escalatorDownSelected,
    required this.escalatorUpSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Préférences sélectionnées"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Retour à la page précédente
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Voici vos préférences sélectionnées :",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(preferences),  // Affiche le texte des préférences sélectionnées

            const SizedBox(height: 20),
            // Affichage visuel des préférences sélectionnées avec des images
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                if (escaliersSelected)
                  Image.asset("assets/images/escaliers.png", width: 40),
                if (escalatorDownSelected)
                  Image.asset("assets/images/escalatordown.png", width: 40),
                if (escalatorUpSelected)
                  Image.asset("assets/images/escalatorup.png", width: 40),
                if (ascenseurSelected)
                  Image.asset("assets/images/ascenseur.png", width: 40),
              ],
            ),
            const SizedBox(height: 20),
            // Bouton "Retour" avec couleur violet clair et texte épuré
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Retour à la page précédente
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.grey,
                backgroundColor: Color(0xFFF5F6F9), // Utilisation du violet clair ici
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                "Retour",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
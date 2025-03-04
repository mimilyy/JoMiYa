import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/signup_controller.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignUpController>(); // ne pas recréer l'instance, cherche celle existante

    return Form( //form est un widget qui permet la validation des champs, géré avec une clé
      key: controller.formKey, //utilise une clé globale définie dans SignUpController pour gérer la validation (dans SignUpController)
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          const Text( //titre du formulaire
            "Créer un compte",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),


          const SizedBox(height: 20),
          TextFormField(    //Champ nom d'utilisateur avec sa validation simple (text non vide)
            controller: controller.usernameController, //lié au controlleur, pour récupérer le contenu du champ, afficher dynamiquement le texte
            decoration: const InputDecoration(
              labelText: "Nom d'utilisateur",
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? "Veuillez entrer un nom d'utilisateur" : null,
          ),



          const SizedBox(height: 10),
          TextFormField(      //Champ email
            controller: controller.emailController,
            decoration: const InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) =>
                value == null || value.isEmpty ? "Veuillez entrer un email" : null,
          ),



          const SizedBox(height: 10),
          TextFormField(   //Champ mot de passe
            controller: controller.passwordController,
            decoration: const InputDecoration(
              labelText: "Mot de passe",
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            validator: (value) =>
                value == null || value.length < 6 ? "Le mot de passe doit contenir au moins 6 caractères" : null,
          ),


          const SizedBox(height: 10),
          TextFormField(   //Champ confirmer le mot de place
            controller: controller.confirmPasswordController,
            decoration: const InputDecoration(
              labelText: "Confirmer le mot de passe",
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            validator: (value) =>
                value == null || value != controller.passwordController.text ? "Les mots de passe ne correspondent pas" : null,
          ),


          const SizedBox(height: 20),
          SizedBox(    //Bouton s'inscrire avec le déclanchement de la logique
            width: double.infinity,
            child: 
             ElevatedButton(
              onPressed: () {
                if (controller.formKey.currentState!.validate()){
            
              //controller.signUp(); // authentication with email and password
              //Auth with phone number also possible

              //Firestore for auth data + signup
              //Passing the user data to the controller
              controller.createUser();
                }},
              child: const Text("S'incrire"),


            ),
          ),



        ],
      ),
    );
  }
}

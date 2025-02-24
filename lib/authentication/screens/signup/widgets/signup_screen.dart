import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'signup_form_widget.dart';
import '../../../controllers/signup_controller.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    //Get.put(SignUpController()); // ✅ Ajout ici pour éviter l'erreur


    return Scaffold(
      appBar: AppBar(
        title: const Text("Inscription"),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: SignUpForm(),
      ),
    );
  }
}

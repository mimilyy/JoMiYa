import 'package:flutter/material.dart';
import 'signin_form_widget.dart';
import 'signin_footer.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connexion"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            SignInForm(),
            SignInFooter(),
          ],
        ),
      ),
    );
  }
}

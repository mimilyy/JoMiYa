import 'package:flutter/material.dart';
import 'signup_form_widget.dart';
import 'signup_footer.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

 
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inscription"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
              SignUpForm(),
              SignUpFooter(),

              ],
              )
        
        

      ),
    );
  }
}

import 'package:elgivesv2/api/firebase_auth_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'signup_page.dart';
import 'dart:convert';



class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

final GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: '63376358868-fq1s6hb0dkt6mg30g4ckkput26mjca55.apps.googleusercontent.com',
  scopes: [
    'email'
  ]
);

bool isValidUsername(String username) {
  return username.isNotEmpty;
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  String? username;
  String? password;
  bool showSignInErrorMessage = false;
  bool _signInPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8D1436),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 80, horizontal: 30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                heading,
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('lib/assets/elgivesLogo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC107),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      usernameField,
                      const SizedBox(height: 20),
                      passwordField,
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                submitButton,
                const SizedBox(height: 20),
                googleSignInButton,
                const SizedBox(height: 15),
                signUpButton,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get heading => Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Text(
          "Sign In",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );

  Widget get usernameField => TextFormField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "Username",
          hintText: "yourusername",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black54),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black),
          ),
          labelStyle: TextStyle(
            color: Colors.black,
          ),
        ),
        onSaved: (value) => setState(() => username = value),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter your username";
          }
          return null;
        },
      );

  Widget get passwordField => TextFormField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "Password",
          hintText: "******",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black54),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black),
          ),
          labelStyle: TextStyle(
            color: Colors.black,
          ),
        ),
        obscureText: true,
        onSaved: (value) => setState(() => password = value),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter your password";
          }
          return null;
        },
      );

  Widget get submitButton => ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            setState(() {
              _signInPressed = true;
            });

            _formKey.currentState!.save();
            String? message = await context.read<UserAuthProvider>().authService.signIn(username!, password!);

            if (message != "Successful!") {
              setState(() {
                showSignInErrorMessage = true;
              });
            } else {
              // Handle successful sign in
            }

            setState(() {
              _signInPressed = false;
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF01563F),
          textStyle: const TextStyle(color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_signInPressed) 
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFC107)),
              ),
            if (!_signInPressed) 
              const Text(
                "Sign in",
                style: TextStyle(
                  color: Color(0xFFFFC107),
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
          ],
        ),
      );

  Future<void> signInWithGoogle() async {
    try {
      await _googleSignIn.signIn();
    } catch (e) {
      print('Error signing in: $e');
    }
  }

  Widget get googleSignInButton => ElevatedButton(
        onPressed: signInWithGoogle,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF01563F),
          textStyle: const TextStyle(color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              FontAwesomeIcons.google,
              color: Colors.white,
            ),
            SizedBox(width: 10.0),
            Text(
              "Sign in with Google",
              style: TextStyle(
                color: Color(0xFFFFC107),
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      );

  Widget get signUpButton => Padding(
        padding: const EdgeInsets.all(30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Create a new account?",
              style: TextStyle(color: Colors.white),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              },
              child: const Text(
                "Sign Up",
                style: TextStyle(
                  color: Color(0xFFFFC107),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
}

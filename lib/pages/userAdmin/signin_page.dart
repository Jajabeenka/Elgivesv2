import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


import 'signup_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool showSignInErrorMessage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 141, 20, 54), // Use primary color from theme
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
                    )),
                const SizedBox(height: 20),
                 const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFFFFC107), // Yellow background color
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    emailField,
                    const SizedBox(height: 20),
                    passwordField,
                  ],
                ),
              ),
                const SizedBox(height: 20),
                showSignInErrorMessage ? signInErrorMessage : Container(),
                const SizedBox(height: 20),
                submitButton,
                const SizedBox(height: 20),
                GoogleSignInButton(), // Add Google Sign-In button
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
            color: Colors.white, // Use yellow text color from theme
          ),
        ),
      );

  Widget get emailField => TextFormField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "Email",
          hintText: "juandelacruz09@gmail.com",
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
        onSaved: (value) => setState(() => email = value),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter your email";
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
      return "Please enter your password"; // Return error message as string
    }
    return null; // Return null if validation succeeds
  },
);

  Widget get signInErrorMessage => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Text(
          "Invalid email or password",
          style: TextStyle(color: Colors.black),
        ),
      );

  Widget get submitButton => ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            String? message = await context
                .read<UserAuthProvider>()
                .authService
                .signIn(email!, password!);

            print(message);
            print(showSignInErrorMessage);

            setState(() {
              showSignInErrorMessage = message != null && message.isNotEmpty;
            });
          }
        },
        style:  ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF01563F), // Button background color
          textStyle: TextStyle(color: Colors.white), // Text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Rounded corners
          ),
          padding: EdgeInsets.symmetric(vertical: 12.0), // Button padding
        ),
       child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            SizedBox(width: 10.0), // Spacing between icon and text
            Text(
              "Sign in ",
              style: TextStyle(
                color: Color(0xFFFFC107),
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      );

  Widget GoogleSignInButton() => ElevatedButton(
        onPressed: () async {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF01563F), // Button background color
          textStyle: TextStyle(color: Colors.white), // Text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Rounded corners
          ),
          padding: EdgeInsets.symmetric(vertical: 12.0), // Button padding
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              color: Colors.white,
              FontAwesomeIcons.google,
            ),
            SizedBox(width: 10.0), // Spacing between icon and text
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
            const Text("Create a new account?",
                style: TextStyle(color: Colors.white)),
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

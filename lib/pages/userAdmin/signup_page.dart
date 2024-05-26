import 'package:elgivesv2/pages/orgsPage.dart';
import 'package:elgivesv2/pages/userAdmin/organization_signup.dart';
import 'package:elgivesv2/pages/userAdmin/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key});

  @override
  State<SignUpPage> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? username;
  String? email;
  String? password;
  List<String>? addresses = []; // Change addresses to List<String>
  String? contactNumber;

  // RegExp: This is a class in Dart used for representing regular expressions.
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 141, 20, 54),
      appBar: AppBar(
        title: Text(
          "Donor Sign Up Page",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFC107),
          ),
        ),
        iconTheme: IconThemeData(color: Color.fromARGB(255, 168, 202, 235)),
        backgroundColor: Color(0xFF01563F),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                heading,
                OrganizationSignUpButton,
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFC107),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      nameField,
                      userNameField,
                      emailField,
                      passwordField,
                      addressField,
                      contactNumberField,
                    ],
                  ),
                ),
                SizedBox(height: 26.0), // Spacing between icon and text
                submitButton,
                SizedBox(height: 15.0), // Spacing between icon and text

                signInButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get heading => Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: Text(
          "Sign Up",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );

  Widget get nameField => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: "Name",
            hintText: "Enter your name",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.black54),
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
            filled: true,
            fillColor: Colors.white,
          ),
          onSaved: (value) => setState(() => name = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Name cannot be empty";
            }
            return null;
          },
        ),
      );

  Widget get userNameField => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: "Username",
            hintText: "Enter your username",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.black54),
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
            filled: true,
            fillColor: Colors.white,
          ),
          onSaved: (value) => setState(() => username = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Username cannot be empty";
            }
            return null;
          },
        ),
      );

  Widget get emailField => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: TextFormField(
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
              borderSide: const BorderSide(color: Colors.black54),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black),
            ),
            labelStyle: const TextStyle(
              color: Colors.black,
            ),
          ),
          onSaved: (value) => setState(() => email = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your email";
            } else if (!isValidEmail(value)) {
              return "Please enter a valid email format";
            }
            return null;
          },
        ),
      );

  Widget get passwordField => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            labelText: "Password",
            hintText: "At least 6 characters",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.black54),
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
          onSaved: (value) => setState(() => password = value),
          validator: (value) {
            if (value == null ||
                value.isEmpty ||
                value.length < 6) {
              return "Password must be at least 6 characters and contain letters, numbers, and special characters.";
            }
            return null;
          },
        ),
      );

  Widget get addressField => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: "Address",
            hintText: "Enter an address",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.black54),
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
            filled: true,
            fillColor: Colors.white,
          ),
          onSaved: (value) {
            if (value != null && value.isNotEmpty) {
              setState(() {
                addresses!.add(value); // Add address to the addresses list
              });
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Address cannot be empty";
            }
            return null;
          },
        ),
      );

  Widget get contactNumberField => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: "Contact Information",
            hintText: "Enter phone number",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.black54),
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
            filled: true,
            fillColor: Colors.white,
          ),
          onSaved: (value) => setState(() => contactNumber = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Contact number cannot be empty";
            }
            return null;
          },
        ),
      );

  Widget get submitButton => ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            try {
              await context.read<UserAuthProvider>().signUp(
                    name!,
                    username!,
                    email!,
                    password!,
                    addresses!,
                    contactNumber!,
                  );
             // Automatically sign in the user after successful sign up
              await context.read<UserAuthProvider>().signIn(email!, password!);

              // Handle successful signup (navigate or show message)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Sign-up and sign-in successful!"),
                  duration: const Duration(seconds: 2),
                ),
              );

              // Navigate to the next page after successful sign-in
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => OrgsPage()), // Replace NextPage with the desired page
              );
            } catch (e) {
              // Handle signup errors
              _showSnackBar("Sign-up failed: $e");
            }
          }
        },
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
              Icons.login, // Add an icon if desired
              color: Colors.white,
            ),
            SizedBox(width: 10.0), // Spacing between icon and text
            Text(
              "Sign Up",
              style: TextStyle(
                color: Color(0xFFFFC107),
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      );

  Widget get OrganizationSignUpButton => Padding(
        padding: const EdgeInsets.all(0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Click to join here as an",
                style: TextStyle(color: Colors.white)),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OrganizationSignUpPage()),
                );
              },
              child: const Text(
                "organization",
                style: TextStyle(
                  color: Color(0xFFFFC107),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );

 

  Widget signInButton() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Already have an account?",
            style: TextStyle(color: Colors.white),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignInPage()),
              );
            },
            child: Text(
              "Sign In",
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
}

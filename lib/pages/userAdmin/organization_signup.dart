import 'package:elgivesv2/pages/userAdmin/signin_page.dart';
import 'package:elgivesv2/pages/userAdmin/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OrganizationSignUpPage extends StatefulWidget {
  const OrganizationSignUpPage({Key? key});

  @override
  State<OrganizationSignUpPage> createState() => _OrganizationSignUpPageState();
}

class _OrganizationSignUpPageState extends State<OrganizationSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String? organizationName;
  String? description;
  String? contactInformation;
  String? email;
  String? password;
  String? proofOfLegitimacy; // This can be a file upload field

  // RegExp for email validation
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // RegExp for password validation
  bool isValidPassword(String password) {
    return RegExp(
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$')
        .hasMatch(password);
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
                SizedBox(height: 10.0),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFC107),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      organizationNameField,
                      descriptionField,
                      contactInformationField,
                      emailField,
                      passwordField,
                      proofOfLegitimacyField,
                    ],
                  ),
                ),
                SizedBox(height: 26.0), // Spacing between fields and buttons
                submitButton,
                SizedBox(height: 15.0), // Additional spacing
                GoogleSignInButton(),
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
          "Organization Sign Up",
          style: TextStyle(
            fontSize: 33,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );

  Widget get organizationNameField => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: "Organization Name",
            hintText: "Enter organization name",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.black54),
            ),
            // Additional styling
            filled: true,
            fillColor: Colors.white,
          ),
          onSaved: (value) => setState(() => organizationName = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Organization name cannot be empty";
            }
            return null;
          },
        ),
      );

  Widget get descriptionField => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: "Description",
            hintText: "Enter organization description",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.black54),
            ),
            // Additional styling
            filled: true,
            fillColor: Colors.white,
          ),
          onSaved: (value) => setState(() => description = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Description cannot be empty";
            }
            return null;
          },
        ),
      );

  Widget get contactInformationField => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: "Contact Information",
            hintText: "Enter contact information",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.black54),
            ),
            // Additional styling
            filled: true,
            fillColor: Colors.white,
          ),
          onSaved: (value) => setState(() => contactInformation = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Contact information cannot be empty";
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
            hintText: "Enter email",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
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
            ),
          ),
          onSaved: (value) => setState(() => password = value),
          validator: (value) {
            if (value == null ||
                value.isEmpty ||
                value.length < 6 ||
                !isValidPassword(value)) {
              return "Password must be at least 6 characters and contain letters, numbers, and special characters.";
            }
            return null;
          },
        ),
      );

  Widget get proofOfLegitimacyField => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: "Proof of Legitimacy (File Upload)",
            hintText: "Upload organization legitimacy proof",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.black54),
            ),
            // Additional styling
            filled: true,
            fillColor: Colors.white,
          ),
          onSaved: (value) => setState(() => proofOfLegitimacy = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please upload proof of legitimacy";
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
              await context.read<UserAuthProvider>().orgSignUp(
                    organizationName!,
                    description!,
                    contactInformation!,
                    email!,
                    password!,
                    proofOfLegitimacy!, // Assuming proof of legitimacy is required
                  );
              // Handle successful signup (navigate or show message)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Sign-up successful!"),
                  duration: const Duration(seconds: 2),
                ),
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
            const Text(
              "Click to join here as a",
              style: TextStyle(color: Colors.white),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignUpPage(),
                  ),
                );
              },
              child: const Text(
                "donor",
                style: TextStyle(
                  color: Color(0xFFFFC107),
                  fontWeight: FontWeight.bold,
                ),
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

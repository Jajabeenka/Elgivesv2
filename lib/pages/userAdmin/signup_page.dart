import 'dart:async';
import 'dart:io';

import 'package:elgivesv2/models/user.dart';
import 'package:elgivesv2/providers/auth_provider.dart';
import 'package:elgivesv2/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  late List<File> files = [];

  String? email;
  String? password;
  String? username;
  String? name;
  String? description;
  String? contactNumber;

  List<String> addresses = ['']; // Initialize with a single address field

// 1 - Admin
//2 - Donor
// 3 - Organization

  int accountType = 2;
  bool multipleAddressesEnabled = false;
  bool _signUpPressed = false;
  bool errorSignup = false;
  String? errorSignupMessage;

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF8D1436),
      appBar: AppBar(
        title: Text(
          "Sign Up Page",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFC107),
          ),
        ),
        backgroundColor: Color(0xFF01563F),
        iconTheme: IconThemeData(color: Color(0xFF8D1436)),
      ),
      body: signUpBody(),
    );
  }

  Widget signUpBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            signInAs(),
            const SizedBox(height: 15),
            fillUpForm(),
            const SizedBox(height: 20),
            signUpButton(),
            const SizedBox(height: 15),
            errorSignup
                ? Center(
                    child: Text(errorSignupMessage!,
                        style: TextStyle(color: Colors.red)))
                : Container(),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget signInAs() {
    return Column(
      children: [
        Text("Sign up as",
            style: TextStyle(fontSize: 14, color: Color(0xFFFFC107))),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color:
                    Colors.white, // Background color for the unselected state
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 100),
                    width: constraints.maxWidth / 2,
                    top: 0,
                    bottom: 0,
                    left: accountType == 2 ? 2 : constraints.maxWidth / 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF01563F),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            setState(() {
                              accountType = 2;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: Text("Donor",
                                  style: TextStyle(
                                      color: accountType == 2
                                          ? Colors.white
                                          : Color(0xFF01563F))),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            setState(() {
                              accountType = 3;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: Text("Organization",
                                  style: TextStyle(
                                      color: accountType == 3
                                          ? Colors.white
                                          : Color(0xFF01563F))),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget fillUpForm() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFFFFC107),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          emailField,
          const SizedBox(height: 10),
          nameField,
          const SizedBox(height: 10),
          userNameField,
          const SizedBox(height: 10),
          passwordField,
          const SizedBox(height: 10),
          contactNumberField,
          const SizedBox(height: 10),
          const SizedBox(height: 10),
          ...addressFields(),
          const SizedBox(height: 10),
          addAnotherAddressButton(),
          const SizedBox(height: 15),
          accountType == 3 ? proofOfLegitimacy() : Container(),
          const SizedBox(height: 15),
          accountType == 3 ? descriptionField() : Container(),
        ],
      ),
    );
  }

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
                value.length < 6 ) {

              return "Password must be at least 6 characters and contain letters, numbers, and special characters.";
            }
            return null;
          },
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

  Widget get contactNumberField => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: "Contact Number",
            hintText: "Enter your number",
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
              return "Number cannot be empty";
            }
            return null;
          },
        ),
      );

  List<Widget> addressFields() {
    List<Widget> addressWidgets = [];
    for (int i = 0; i < addresses.length; i++) {
      addressWidgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: addresses[i],
                  decoration: InputDecoration(
                    labelText: "Address ${i + 1}",
                    hintText: "Enter address",
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
                  onChanged: (value) {
                    addresses[i] = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Address cannot be empty";
                    }
                    return null;
                  },
                ),
              ),
              if (i > 0)
                IconButton(
                  icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      addresses.removeAt(i);
                    });
                  },
                ),
            ],
          ),
        ),
      );
    }
    return addressWidgets;
  }

  Widget addAnotherAddressButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            addresses.add('');
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF01563F), // Background color
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, color: Color(0xFFFFC107)),
            SizedBox(width: 10),
            Text(
              "Add Another Address",
              style: TextStyle(
                color: Color(0xFFFFC107),
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget proofOfLegitimacy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Text("Proof of Legitimacy",
            style: TextStyle(
                color: Color(0xFF01563F),
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xFF01563F)),
          ),
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              for (int i = 0; i < files.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(files[i].path.split('/').last,
                            style: TextStyle(color: Colors.black)),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            files.removeAt(i);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              GestureDetector(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.arrow_upward_rounded, color: Colors.white),
                  label: Text("Upload", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF01563F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  ),
                  onPressed: () async {
                    final filesResult = await FilePicker.platform.pickFiles(
                      allowMultiple: true,
                    );
                    if (filesResult != null && filesResult.files.isNotEmpty) {
                      for (var file in filesResult.files) {
                        String fileName = file.path!.split('/').last;
                        bool fileExists = files.any((existingFile) =>
                            existingFile.path.split('/').last == fileName);
                        if (!fileExists) {
                          files.add(File(file.path!));
                        }
                      }
                      setState(() {});
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget descriptionField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: "Organization Description",
          hintText: "Enter your description",
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
        onSaved: (value) => setState(() => description = value),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Description cannot be empty";
          }
          return null;
        },
      ),
    );
  }

  Widget signUpButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: GestureDetector(
        child: ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              setState(() {
                _signUpPressed = true;
              });
              await _handleSignUp();
              setState(() {
                _signUpPressed = false;
              });
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
        ),
      ),
    );
  }

  Future<void> _handleSignUp() async {
    try {
      final userAuthProvider = context.read<UserAuthProvider>();
      final userProvider = context.read<UserProvider>();

      bool isUsernameUnique =
          await userAuthProvider.isUsernameUnique(username!);
      print(isUsernameUnique);

      if (isUsernameUnique) {
        String? uid = await userAuthProvider.signUp(
          email!,
          password!,
          username!,
          name!,
          contactNumber!,
          description!,
          addresses,
          accountType,
          // Set status based on account type
          accountType == 2 ? true : false,
        );

        if (uid != null && !uid.contains("Error")) {
          if (accountType == 3 && files.isNotEmpty) {
            AppUser userDetails = AppUser(
              email: email!,
              uid: uid,
              username: username!,
              name: name!,
              contactNumber: contactNumber!,
              description: description!,
              addresses: addresses,
              accountType: accountType,
              // Set status based on account type
              status: false,
            );

            await userProvider.updateUser(uid, userDetails);
          }

          if (mounted) {
            Navigator.pop(context);
          }
        } else {
          setState(() {
            errorSignup = true;
            errorSignupMessage = uid ?? "Unknown error occurred";
          });
        }
      } else {
        setState(() {
          errorSignup = true;
          errorSignupMessage = "Username already exists!";
        });
      }
    } catch (error) {
      print("Error during sign up: $error");
    }
  }
}

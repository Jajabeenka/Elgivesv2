import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:elgivesv2/models/user.dart';
import 'package:elgivesv2/providers/auth_provider.dart';
import 'package:elgivesv2/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../provider/add_image.dart';
import '../../slambook_widgets/utils.dart';

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
  String? contactNumber;

  List<String> addresses = [''];
  String? description;

  List<String> proof = [];

  int accountType = 2;
  bool multipleAddressesEnabled = false;
  bool _signUpPressed = false;
  bool errorSignup = false;
  String? errorSignupMessage;
  List<Uint8List> _selectedImages = [];

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8D1436),
      appBar: AppBar(
        title: const Text(
          "Sign Up Page",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFC107),
          ),
        ),
        backgroundColor: const Color(0xFF01563F),
        iconTheme: const IconThemeData(color: Color(0xFF8D1436)),
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
            if (errorSignup)
              Center(
                child: Text(
                  errorSignupMessage ?? '',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget signInAs() {
    return Column(
      children: [
        const Text(
          "Sign up as",
          style: TextStyle(fontSize: 14, color: Color(0xFFFFC107)),
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
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
                        color: const Color(0xFF01563F),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              child: Text(
                                "Donor",
                                style: TextStyle(
                                  color: accountType == 2
                                      ? Colors.white
                                      : const Color(0xFF01563F),
                                ),
                              ),
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
                              child: Text(
                                "Organization",
                                style: TextStyle(
                                  color: accountType == 3
                                      ? Colors.white
                                      : const Color(0xFF01563F),
                                ),
                              ),
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
        color: const Color(0xFFFFC107),
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
          ...addressFields(),
          const SizedBox(height: 10),
          addAnotherAddressButton(),
          const SizedBox(height: 15),
          if (accountType == 3) descriptionField,
          const SizedBox(height: 15),
          if (accountType == 3) proofOfLegitimacy(),
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
            if (value == null || value.isEmpty || value.length < 6) {
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
            hintText: "Enter your contact number",
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

  Widget get descriptionField => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: TextFormField(
          maxLines: 5,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            labelText: "Description",
            hintText: "Describe your organization",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black54),
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
          onSaved: (value) => setState(() => description = value),
        ),
      );

  List<Widget> addressFields() {
    List<Widget> addressWidgets = [];
    for (int i = 0; i < addresses.length; i++) {
      addressWidgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: TextFormField(
            initialValue: addresses[i],
            decoration: InputDecoration(
              labelText: "Address ${i + 1}",
              hintText: "Enter your address",
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
            onSaved: (value) => addresses[i] = value ?? '',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Address cannot be empty";
              }
              return null;
            },
          ),
        ),
      );
    }
    return addressWidgets;
  }

  Widget addAnotherAddressButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          addresses.add('');
        });
      },
      child: Text(
        "Add another address",
        style: TextStyle(
          fontSize: 12,
          fontStyle: FontStyle.italic,
          color: Color(0xFF01563F),
        ),
      ),
    );
  }

  Widget proofOfLegitimacy() {
  Uint8List? _image;
  // List<String> proof = [];
  
  int generateUniqueId() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(900) + 100; // Generate a random number between 100 and 999
    return int.parse('${now}${random}');
  }

  void selectImage() async{
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
        _image = img;
        _selectedImages.add(img);
    });
    String? photoUrl;
    if (_image != null) {
      int index = generateUniqueId();
      photoUrl = await StoreData().saveData(file: _image!, index: index);
      // index++;
    }
    else{
      photoUrl='';
    }
    proof.add(photoUrl);
  }
  String? photoUrl;

  Future<String> saveProfile() async{
    String? photoUrl;
    if (_image != null) {
      int index = generateUniqueId();
      photoUrl = await StoreData().saveData(file: _image!, index: index);
      // index++;
    }
    return photoUrl ?? '';
  }
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 15),
      Text("Proof of Legitimacy", style: TextStyle(color: Color(0xFF01563F), fontSize: 16, fontWeight: FontWeight.bold)),
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
                      child: Text(files[i].path.split('/').last, style: TextStyle(color: Colors.black)),
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
                onPressed: selectImage,
                // proof.add(saveProfile());
              ),
            ),
            const SizedBox(height: 10),
        Text("Recently selected Image", style: TextStyle(color: Color(0xFF01563F), fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 300,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _selectedImages.isNotEmpty
                    ? Image.memory(
                        _selectedImages.last,  // Display the most recent image
                        fit: BoxFit.cover,
                        width: 300,
                        height: 100,
                      )
                    : Center(
                        child: Icon(
                          Icons.person,
                          color: Color(0xFFFFC107),
                          size: 36,
                        ),
                      ),
              ),
            ),
          ],
        ),
          ],
        ),
      ),
    ],
  );
}

  Widget proofImages() {
    return _selectedImages.isEmpty
        ? Container()
        : Column(
            children: [
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedImages.map((image) {
                  return Stack(
                    children: [
                      Image.memory(
                        image,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedImages.remove(image);
                            });
                          },
                          child: const Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
            ],
          );
  }

  // Widget addProofButton() {
  //   return ElevatedButton(
  //     onPressed: () async {
  //       Uint8List? pickedImage = await pickImage();
  //       if (pickedImage != null) {
  //         setState(() {
  //           _selectedImages.add(pickedImage);
  //         });
  //       }
  //     },
  //     style: ElevatedButton.styleFrom(
  //       foregroundColor: Color(0xFFFFC107),
  //       backgroundColor: Color(0xFF01563F),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //     ),
  //     child: Text("Add proof"),
  //   );
  // }

  // Future<Uint8List?> pickImage() async {
  //   final ImagePicker _picker = ImagePicker();
  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //   if (image != null) {
  //     return await image.readAsBytes();
  //   }
  //   return null;
  // }

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
            addresses,
            accountType,
            // Set status based on account type
            accountType == 2 ? true : false,
            '',
            proof);

        if (uid != null && !uid.contains("Error")) {
          if (accountType == 3 && files.isNotEmpty) {
            AppUser userDetails = AppUser(
                email: email!,
                uid: uid,
                username: username!,
                name: name!,
                contactNumber: contactNumber!,
                addresses: addresses,
                accountType: accountType,
                // Set status based on account type
                status: false,
                description: description!,
                proof: proof);

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

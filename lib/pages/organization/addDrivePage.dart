// ignore_for_file: prefer_const_constructors

import 'package:elgivesv2/provider/donationDrive_provider.dart';
import 'package:elgivesv2/slambook_widgets/checkbox_donations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import '../../providers/auth_provider.dart';
import '../../slambook_widgets/driveName.dart';
import '../../slambook_widgets/description.dart';
import '../../models/drive.dart';
import 'package:provider/provider.dart';
import '../../provider/donationDrive_provider.dart';
// class AddDrivePage extends StatelessWidget {
//   const AddDrivePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Add Donation Drive',
//       home: Scaffold(
//         appBar: AppBar(
//         title: const Text('Donation Drive', 
//               style: TextStyle(color: Colors.white),
//               ),
//         backgroundColor: const Color.fromARGB(255, 8, 64, 60),
//         ),
//         body: Column (
//           children: [
//             Container(
//               width: 280,
//               margin: EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 10),
//               // ignore: prefer_const_constructors
//               child: TextField(
//                 // ignore: prefer_const_constructors
//                 style: TextStyle(
//                   fontSize: 20,
//                   height: 1.3,
//                   color: Colors.black
//                 ),
//                 // ignore: prefer_const_constructors
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   labelText: "Name",
//                   labelStyle: TextStyle(
//                     fontSize: 20,
//                     color: Colors.black
//                   )
//                 )
//               )
//             ),
//             Container(
//               width: 280,
//               margin: EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 10),
//               // ignore: prefer_const_constructors
//               child: TextField(
//                 style: TextStyle(
//                   fontSize: 20,
//                   height: 1.3,
//                   color: Colors.black
//                 ),
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   labelText: "Description",
//                   labelStyle: TextStyle(
//                     fontSize: 20,
//                     color: Colors.black
//                   )
//                 )
//               )
//             ),
//           ],
//         )
//       ),
//     );
//   }
// }

class AddDrivePage extends StatefulWidget {
  const AddDrivePage({super.key});

  @override
  State<AddDrivePage> createState() => _AddDrivePageState();
}

class _AddDrivePageState extends State<AddDrivePage> {
  final _formKey = GlobalKey<FormState>();

  bool showText = false;
  String driveName = "";
  String description = "";
  List<String> donationList = [];
  int driveId = 0;

  int generateDriveId() {
    final random = (Random().nextInt(999999)+1) + (Random().nextInt(99)+1);
    return random;
  }

  void initState() {
    super.initState();
    driveId = generateDriveId();
  }

  void resetFields() {
    setState(() {
      driveName = "";
      String description = "";
      List<String> donationList = [];
    });
  }

  @override
  Widget build(BuildContext context) {

    String? getUserId() {
      User? user = context.read<UserAuthProvider>().user;
      if (user != null) {
        return user.uid;
      }
      return null;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Drive', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFC107),)),
        backgroundColor: Color(0xFF01563F),
        iconTheme: IconThemeData(color: Color(0xFF8D1436)),
      ),
      backgroundColor: Color(0xFF8D1436),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column( 
            children: [
              SizedBox(height: 30,),
              Row( 
                mainAxisAlignment: MainAxisAlignment.center,
                children: [ 
                  Icon(
                    Icons.business,
                    color: Colors.white,
                    size: 30, // Adjust the size as needed
                  ),
                  // SizedBox(width: 8), // Add some spacing between the icon and text
                  // Text(
                  //   widget.orgName,
                  //   style: TextStyle(
                  //     fontSize: 35.0,
                  //     fontWeight: FontWeight.bold,
                  //     color: Color.fromARGB(255, 255, 255, 255),
                  //   ),
                  // ),
                ],
              ),
              DriveName((value) {
                setState(() {
                  driveName = value;
                });
              }),
              Description((value) {
                setState(() {
                  description = value;
                });
              }),
              CheckboxDrive(),
              SizedBox(height: 20,),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom( 
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    backgroundColor: Color.fromARGB(255, 80, 196, 90),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState?.save();
                      Drive drive = Drive(
                        orgId: getUserId(),
                        driveId: driveId, 
                        driveName: driveName,
                        description: description
                      );
                      setState(() {
                        showText = true;
                      });
                      context.read<DonationDriveProvider>().addDrive(drive);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Drive added!"),
                          duration: const Duration(seconds: 1, milliseconds: 100),
                        ),
                      );
                    }
                  },
                  icon: Icon(Icons.check, size: 25),
                  label: Text(
                    "ADD",
                    style: TextStyle(
                      color: Color.fromARGB(255, 7, 6, 0),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      _formKey.currentState!.reset();
                      resetFields();
                      setState(() {
                        showText = false;
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Drive cancelled!"),
                          duration: const Duration(seconds: 1, milliseconds: 100),
                        ),
                      );
                    },
                    icon: Icon(Icons.cancel, size: 25),
                    label: Text(
                      "CANCEL",
                      style: TextStyle(
                        color: Color(0xFFFFC107),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
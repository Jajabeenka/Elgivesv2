import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../slambook_widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/drive.dart';
import '../../provider/donationDrive_provider.dart';
import '../../api/firebase_auth_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

class OrgProfile extends StatelessWidget {

  const OrgProfile({super.key});

  @override
  Widget build(BuildContext context) {

    // Stream<QuerySnapshot> donationDriveListStream =
    //     context.watch<DonationDriveProvider>().drive;

    // String? getUserId() {
    //   User? user = context.read<UserAuthProvider>().user;
    //   if (user != null) {
    //     return user.uid;
    //   }
    //   return null;
    // }

    // User? user = FirebaseAuth.instance.currentUser;

    // // Check if the user is signed in
    // if (user != null) {
    //   String uid = user.uid; // <-- User ID
    //   String? email = user.email; // <-- Their email
    // }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Organization Profile', 
              style: TextStyle(color: Colors.white),
              ),
        backgroundColor: const Color.fromARGB(255, 8, 64, 60),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF9F1010),
        ),
        child: Column(
          children: [ 
            // StreamBuilder(
            //   stream: context.watch<UserProvider>().orgStream, // Use the donorStream from UserProvider
            //   builder: (context, snapshot) {
            //     if (snapshot.hasError) {
            //       return Center(
            //         child: Text("Error encountered! ${snapshot.error}"),
            //       );
            //     } else if (snapshot.connectionState == ConnectionState.waiting) {
            //       return Center(
            //         child: CircularProgressIndicator(),
            //       );
            //     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            //       return const Center(
            //         child: Text("No Donor Found"),
            //       );
            //     }

            //     final donor = snapshot.data!.firstWhere(
            //         (user) => user.uid == getUserId());
            // }),
            SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(6.0),
                padding: const EdgeInsets.all(7.0),
                width: MediaQuery.of(context).size.width,
                height: 175.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: const Color.fromARGB(255, 255, 255, 255),
                  border: Border.all(
                    width: 5,
                    color: const Color(0xFFFFC107),
                  )
                ),
                child: const Column(
                children: [
                  //org logo and name
                  Row(
                    children: [
                      Text('Elgives Charity', style: TextStyle(color: Color(0xFF9F1010), fontWeight: FontWeight.bold)),
                      Spacer(),
                        //edit button
                      Align(
                        alignment: Alignment.topRight,
                        child: SizedBox(
                          width: 30.0,
                          height: 30.0,
                          child: FittedBox(
                            child: FloatingActionButton(
                              onPressed: null,
                              child: Icon(Icons.edit),
                            ),
                          ),
                        )
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    children: [
                      Text('About', style: TextStyle(color: Color(0xFF9F1010), fontSize: 25, fontWeight: FontWeight.bold)),
                    ],
                  ),                  
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    ),
                  ),
                ],
              ),
              )
            ),
            //list of charities
            Expanded (
              child: ListView(
                children: [
                  Container (
                    margin: const EdgeInsets.all(6.0),
                    padding: const EdgeInsets.all(7.0),
                    height: 60.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: const Color.fromARGB(255, 255, 255, 255),
                      border: Border.all(
                        width: 2,
                        color: Colors.black,
                      )
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Charity Name", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text("OPEN", style: TextStyle(color: Color.fromARGB(255, 8, 64, 60), fontSize: 20, fontWeight: FontWeight.bold)),
                      ],),
                  ),
                ],
              )
            ),
            Container(
              margin: const EdgeInsets.all(6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 30.0,
                    height: 30.0,
                    child: FittedBox(
                      child: FloatingActionButton(
                        onPressed: null,
                        child: Icon(Icons.arrow_back),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30.0,
                    height: 30.0,
                    child: FittedBox(
                      child: FloatingActionButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/donationDrive');
                        },
                        child: Icon(Icons.arrow_forward),
                      ),
                    ),
                  ),
                ]
              ),
            )
          ],
        ),
      ),

    );
  }
}


// child: ElevatedButton(
        //   child: const Text('Go to Second route'),
        //     onPressed: () {
        //     // Navigate to second route
        //     },
        //   ),

        
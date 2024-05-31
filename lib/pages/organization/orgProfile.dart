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
import '../../slambook_widgets/drive.dart';
import '../../slambook_widgets/qr_scanner.dart';

class OrgProfile extends StatefulWidget {
  @override
  _OrgProfileState createState() => _OrgProfileState();
}

class _OrgProfileState extends State<OrgProfile> {
  void initState() {
    super.initState();
    // Fetch organizations data here
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final driveProvider =
          Provider.of<DonationDriveProvider>(context, listen: false);
      driveProvider.fetchDonationDriveList();
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.fetchOrganizations();
      userProvider.fetchDonors();
    });
  }

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
    Stream<QuerySnapshot> donationDriveStream =
        context.watch<DonationDriveProvider>().drive;
    String? getUserId() {
      User? user = context.read<UserAuthProvider>().user;
      if (user != null) {
        return user.uid;
      }
      return null;
    }

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Organization Profile',
      //         style: TextStyle(color: Colors.white),
      //         ),
      //   backgroundColor: const Color.fromARGB(255, 8, 64, 60),
      // ),
      body: Stack(
        children: [
          Container(
            height: 170,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade800,
                  Colors.blue.shade400,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          StreamBuilder(
            stream: context
                .watch<UserProvider>()
                .orgStream, // Use the donorStream from UserProvider
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Error encountered! ${snapshot.error}"),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("No Donor Found"),
                );
              }

              final org =
                  snapshot.data!.firstWhere((user) => user.uid == getUserId());

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 80),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Icon(
                              Icons.account_circle,
                              size: 120,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        org.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '@${org.username}',
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 12.0),
                        decoration: BoxDecoration(
                          color: org.status
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          org.status ? 'OPEN' : 'CLOSED',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Addresses',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 8),
                              ...org.addresses.map(
                                (address) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.blue,
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          address,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Contact Number',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.phone,
                                    color: Colors.blue,
                                    size: 18,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    org.contactNumber,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                      StreamBuilder(
                        stream: donationDriveStream,
                        // .where((donation) =>
                        //     donation.data()['userId'] == getUserId()),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child:
                                  Text("Error encountered! ${snapshot.error}"),
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const Center(
                              child: Text("No Donations Found"),
                            );
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (context, index) {
                              Drive drive = Drive.fromJson(
                                  snapshot.data?.docs[index].data()
                                      as Map<String, dynamic>);
                              if (drive.orgId == getUserId()) {
                                return DriveWidget(drive: drive);
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 16.0,
            right: 165.0,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScanQRCode()),
                );
              },
              child: Icon(Icons.qr_code_scanner),
            ),
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
                ]),
          )
        ],
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

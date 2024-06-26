import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/donor.dart';
import '../../models/donation.dart';
import '../../models/user.dart';
import '../../provider/donation_provider.dart';
import '../../provider/donor_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart'; 
import '../../slambook_widgets/donations.dart';
import '../../slambook_widgets/drawer.dart';
import '../../slambook_widgets/qr_scanner.dart';

class ProfilePage extends StatefulWidget {
@override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Fetch organizations data here
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final donationProvider = Provider.of<DonationProvider>(context, listen: false);
      donationProvider.fetchDonationsList();
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.fetchOrganizations();
      userProvider.fetchDonors();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    // Stream<QuerySnapshot> donorsListStream = context.watch<DonorProvider>().donor;
    final donationProvider  = Provider.of<DonationProvider>(context);
    Stream<QuerySnapshot> donationsListStream =
        context.watch<DonationProvider>().donation;

    String? getUserId() {
      User? user = context.read<UserAuthProvider>().user;
      if (user != null) {
        return user.uid;
      }
      return null;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        elevation: 0,
        backgroundColor: Color(0xFF01563F),
        foregroundColor: Color(0xFFFFC107),
      ),
      extendBodyBehindAppBar: true,
      drawer: DrawerWidget(),
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
            stream: context.watch<UserProvider>().donorStream, // Use the donorStream from UserProvider
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

              final donor = snapshot.data!.firstWhere(
                  (user) => user.uid == getUserId());

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
                        donor.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '@${donor.username}',
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color.fromARGB(255, 0, 0, 0),
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
                              ...donor.addresses.map(
                                (address) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                    donor.contactNumber,
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
                        stream: donationsListStream,
                        // .where((donation) =>
                        //     donation.data()['userId'] == getUserId()),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                  "Error encountered! ${snapshot.error}"),
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
                              Donation donation = Donation.fromJson(
                                  snapshot.data?.docs[index].data()
                                      as Map<String, dynamic>);
                                    if(donation.userId == getUserId())
                                    {
                                      return DonationWidget(donation: donation);
                                    }
                                    else {
                                      return const SizedBox.shrink();}
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
            right: 16.0,
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
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elgivesv2/api/firebase_donationDrive_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../models/drive.dart';
import '../provider/donationDrive_provider.dart';
import 'donationDriveModal.dart';
import 'dart:math';

class DonationDrive extends StatefulWidget {

  const DonationDrive({super.key});

  @override
  State<DonationDrive> createState() => _DonationDriveState();
}

class _DonationDriveState extends State<DonationDrive> {
  // final FirestoreService firestoreService = FirestoreService();
  //text controller
  // final TextEditingController textController = TextEditingController();

  //dialog box to add a donation drive
  void addDrive() {
    showDialog(
      context: context, 
      builder: (BuildContext context) => DonationDriveModal(
        type: 'Add',
        item: null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> driveStream = context.watch<DonationDriveProvider>().drive;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation Drive', 
              style: TextStyle(color: Colors.white),
              ),
        backgroundColor: const Color.fromARGB(255, 8, 64, 60),
      ),
      body: StreamBuilder(
        stream:driveStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error encountered! ${snapshot.error}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text("No Donation Drives Found"),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: ((context, index) {
              Drive drive = Drive.fromJson(
                  snapshot.data?.docs[index].data() as Map<String, dynamic>);
              drive.id = snapshot.data?.docs[index].id;
              return Dismissible(
                key: Key(drive.id.toString()),
                onDismissed: (direction) {
                  context.read<DonationDriveProvider>().deleteDrive(drive.driveName);

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${drive.driveName} dismissed')));
                },
                background: Container(
                  color: Colors.red,
                  child: const Icon(Icons.delete),
                ),
                child: ListTile(
                  title: Text(drive.driveName),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => DonationDriveModal(
                              type: 'Edit',
                              item: drive,
                            ),
                          );
                        },
                        icon: const Icon(Icons.create_outlined),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => DonationDriveModal(
                              type: 'Delete',
                              item: drive,
                            ),
                          );
                        },
                        icon: const Icon(Icons.delete_outlined),
                      )
                    ],
                  ),
                ),
              );
            }),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => DonationDriveModal(
              type: 'Add',
              item: null,
            ),
          );
        },
        child: const Icon(Icons.add_outlined),
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


// Container(
//         decoration: const BoxDecoration(
//           color: Color(0xFF9F1010),
//         ),
//         child: Column(
//           children: [ 
//             //list of charities
//             Expanded (
//               child: ListView(
//                 children: [
//                   Container (
//                     margin: const EdgeInsets.all(6.0),
//                     padding: const EdgeInsets.all(7.0),
//                     height: 60.0,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(6),
//                       color: const Color.fromARGB(255, 255, 255, 255),
//                       border: Border.all(
//                         width: 2,
//                         color: Colors.black,
//                       )
//                     ),
//                     child: const Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text("Donation 1", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                       ],),
//                   ),
//                   Container (
//                     margin: const EdgeInsets.all(6.0),
//                     padding: const EdgeInsets.all(7.0),
//                     height: 60.0,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(6),
//                       color: const Color.fromARGB(255, 255, 255, 255),
//                       border: Border.all(
//                         width: 2,
//                         color: Colors.black,
//                       )
//                     ),
//                     child: const Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text("Donation 2", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                       ],),
//                   ),
//                 ],
//               )
//             ),
//             Container(
//               margin: const EdgeInsets.all(6.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   SizedBox(
//                     width: 30.0,
//                     height: 30.0,
//                     child: FittedBox(
//                       child: FloatingActionButton(
//                         onPressed: null,
//                         child: Icon(Icons.arrow_back),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 30.0,
//                     height: 30.0,
//                     child: FittedBox(
//                       child: FloatingActionButton(
//                         onPressed: addDrive,
//                         child: Icon(Icons.add),
//                       ),
//                     ),
//                   ),
//                 ]
//               ),
//             )
//           ],
//         ),
//       ),
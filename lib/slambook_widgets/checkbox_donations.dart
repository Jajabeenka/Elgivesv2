import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elgivesv2/pages/organization/donationsList.dart';
import 'package:flutter/material.dart';

class CheckboxDrive extends StatefulWidget {
  // final Function callback;
  const CheckboxDrive({super.key});

  @override
  State<CheckboxDrive> createState() => _CheckboxDriveState();
}

class _CheckboxDriveState extends State<CheckboxDrive> {
  // final TextEditingController _CheckboxDriveController = TextEditingController();

  // @override
  // // void dispose() {
  // //   _CheckboxDriveController.dispose();
  // //   super.dispose();
  // // }

  // List<Widget> _widgetOptions = <Widget>[
  //   DonationListPage(), // Add AllDonationsPage as one of the options
  // ]; 

  Stream<QuerySnapshot> donations = FirebaseFirestore.instance.collection('donations').snapshots();

  @override
  Widget build(BuildContext context) {
    bool value = false;

    return StreamBuilder<QuerySnapshot>(
      stream: donations, 
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading');
        }

        return SizedBox(
          height: 300,
          child: ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot document = snapshot.data!.docs[index];
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return  Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Text(
                      'Add Donations:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF01563F),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20), // Padding added here
                    child: CheckboxListTile(
                      title: Text(data['donationId'].toString()),
                      value: value,
                      activeColor: Colors.blue,
                      checkColor: Colors.blue,
                      onChanged: (bool? value) {
                        setState(() {
                          if(value == false) {
                            value = true;
                          }
                          else {
                            value = false;
                          }
                        });
                      },
                      )
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          }, ),
        );
      });
  }
}
import 'package:flutter/material.dart';
import '../provider/donation_provider.dart';
import '../slambook_widgets/time.dart';
import '../slambook_widgets/weight.dart';
import '../slambook_widgets/mode.dart';
import '../slambook_widgets/address.dart';
import '../slambook_widgets/date.dart';
import '../slambook_widgets/item.dart';
import '../slambook_widgets/drawer.dart';
import '../slambook_widgets/contactNum.dart';
import '../models/donation.dart'; // Import the Friend class
import 'package:provider/provider.dart';
import '../provider/orgs_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/donation.dart';


class FormSample extends StatefulWidget {

  const FormSample({Key? key}) : super(key: key);

  @override
  State<FormSample> createState() => _FormSampleState();
}

class _FormSampleState extends State<FormSample> {
  final _formKey = GlobalKey<FormState>();

  bool showText = false;
  List<String> categories = [];
  String pickupOrDropOff = "PickUp";
  String weight = "";
  String? photo;
  DateTime dateTime = DateTime.now();
  List<String> addresses = [];
  String contact = "";

  void resetFields() {
  setState(() {
    categories = []; 
    pickupOrDropOff = "Pickup"; 
    weight = ""; 
    photo = null; 
    dateTime = DateTime.now();
    addresses = []; 
    contact = "";
  });

  setState(() {
    pickDrop = Mode(
      initialValue: 'Pickup',
      onChanged: (initialValue) {
        setState(() {
          pickupOrDropOff = initialValue;
        });
      },
    );
  });
}

  late Mode pickDrop;
  
  @override
  Widget build(BuildContext context) {
    DateTime initialDateTime = DateTime.now();
    pickDrop = Mode(
      initialValue: 'Pickup', 
      onChanged: (value) {
        setState(() {
          pickupOrDropOff = value; 
        });
      },
    );

    return Scaffold(
      // margin: EdgeInsets.all(20),
      drawer: DrawerWidget(text: "Organization"),
      appBar: AppBar(
        title: Text(
          "Donate Page",
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFC107),
          ),
        ),
        backgroundColor: Color(0xFF01563F),
        iconTheme: IconThemeData(color: Color(0xFF8D1436)),
      ),
      backgroundColor: Color(0xFF8D1436), //
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 30,),
              Text(
                'NAME OF ORG',
                style: TextStyle(
                  fontSize: 27.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              Item(
                onChanged: (selectedOptions) {
                  setState(() {
                    categories = selectedOptions;
                  });
                },
                selectedOptions: categories,
              ),
              pickDrop,
              Weight((value) {
                setState(() {
                  weight = value;
                });
              }),
              Date((date) {
                setState(() {
                  dateTime = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    dateTime.hour,
                    dateTime.minute,
                  );
                });
              }, dateTime: dateTime),
              Time((time) {
                setState(() {
                  dateTime = DateTime(
                    dateTime.year,
                    dateTime.month,
                    dateTime.day,
                    time.hour,
                    time.minute,
                  );
                });
              }, dateTime: dateTime),
              Address((addressList) {
                setState(() {
                  addresses = addressList;
                });
              }),
              contactNumber((value) {
                setState(() {
                  contact = value;
                });
              }),
              ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: (dateTime.isBefore(DateTime.now())) || addresses.isEmpty
                    ? Colors.grey.shade400
                    : Color.fromARGB(255, 80, 196, 90),
                disabledBackgroundColor: Colors.grey.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: (dateTime.isBefore(DateTime.now())) || addresses.isEmpty || addresses.contains("")
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState?.save();
                        Donation donation = Donation(
                          categories: categories,
                          pickupOrDropOff: pickupOrDropOff,
                          weight: weight,
                          photo: "",
                          dateTime: dateTime,
                          addresses: addresses,
                          contactNumber: contact,
                        );
                        setState(() {
                          showText = true;
                        });
                        context.read<DonationProvider>().addDonation(donation);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Donation added!"),
                            duration: const Duration(seconds: 1, milliseconds: 100),
                          ),
                        );
                      }
                    },
                child: Text(
                  "Donate",
                  style: TextStyle(
                    color: Color.fromARGB(255, 7, 6, 0),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                margin: EdgeInsets.all(20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
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
                        content: Text("Donation cancelled!"),
                        duration: const Duration(seconds: 1, milliseconds: 100),
                      ),
                    );
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Color(0xFFFFC107),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

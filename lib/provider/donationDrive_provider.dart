import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../api/firebase_donationDrive_api.dart';
import '../models/drive.dart';

class DonationDriveProvider with ChangeNotifier {

  FirebaseTodoAPI firebaseService = FirebaseTodoAPI();
  // late Stream<QuerySnapshot> _donationsListStream;
  late Stream<QuerySnapshot> _donationDriveListStream;

  DonationDriveProvider() {
    // fetchDonationsList();
    fetchDonationDriveList();
  }
  // getter
  // Stream<QuerySnapshot> get donation => _donationsListStream;
  Stream<QuerySnapshot> get donationDrive => _donationDriveListStream;
  
  //get friends from the database
  void fetchDonationDriveList() {
    _donationDriveListStream = firebaseService.getAllDrives();
    notifyListeners();
  }

  //add friend to the databsae
  void addDrive (Drive drive) async {
    String message = await firebaseService.addDrive(drive.toJson(drive));
    print(message);
    notifyListeners();
  }

  // //delete

  // //edits
}

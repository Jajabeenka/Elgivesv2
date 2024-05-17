import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../api/firebase_donor_api.dart';
import '../models/donor.dart';

class DonorProvider with ChangeNotifier {

  FirebaseTodoAPI firebaseService = FirebaseTodoAPI();
  late Stream<QuerySnapshot> _donorsListStream;

  DonorProvider() {
    fetchDonorsList();
  }
  // getter
  Stream<QuerySnapshot> get donor => _donorsListStream;
  
  //get friends from the database
  void fetchDonorsList() {
    _donorsListStream = firebaseService.getAllDonors();
    notifyListeners();
  }
}
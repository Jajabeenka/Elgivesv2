import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../api/firebase_donationsList_api.dart';
import '../models/donation.dart';

class DonationProvider with ChangeNotifier {
  // List<Friend> _friends = [];
  // List<Friend> get friendsList => _friends;

  FirebaseTodoAPI firebaseService = FirebaseTodoAPI();
  late Stream<QuerySnapshot> _donationsListStream;

  DonationProvider() {
    fetchDonationsList();
  }
  // getter
  Stream<QuerySnapshot> get donation => _donationsListStream;
  
  //get friends from the database
  void fetchDonationsList() {
    _donationsListStream = firebaseService.getAllDonations();
    notifyListeners();
  }

  //add friend to the databsae
  void addDonation (Donation donation) async {
    // _friends.add(friend);
    // notifyListeners();
    String message = await firebaseService.addDonation(donation.toJson(donation));
    print(message);
    notifyListeners();
  }

  //delete friend from the datbase
  // void deleteFriend(String id) async{
  //   // _friends.remove(friend);
  //   // notifyListeners();
  //   await firebaseService.deleteTodo(id);
  //   notifyListeners();
  // }

  //edits info of a friend with the given index from the databse
  // void editFriend(String nickname, String age, bool status, double happiness, String superpower, String motto, String id) async {
  //   // Navigator.push(
  //   //   context,
  //   //   MaterialPageRoute(
  //   //     builder: (context) => EditPage(friend: friend)));
  //   // _friends[index] = friend;
  //   // notifyListeners();
  //   await firebaseService.editTodo(nickname, age, status, happiness, superpower, motto, id);
  //   notifyListeners();
  // }
}

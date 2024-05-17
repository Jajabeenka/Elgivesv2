import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../api/firebase_orgsList_api.dart';
import '../models/organization.dart';

class OrganizationProvider with ChangeNotifier {
  // List<Friend> _friends = [];
  // List<Friend> get friendsList => _friends;

  FirebaseTodoAPI firebaseService = FirebaseTodoAPI();
  late Stream<QuerySnapshot> _organizationsListStream;

  OrganizationProvider() {
    fetchOrganizationsList();
  }
  // getter
  Stream<QuerySnapshot> get organization => _organizationsListStream;
  
  //get friends from the database
  void fetchOrganizationsList() {
    _organizationsListStream = firebaseService.getAllOrganizations();
    notifyListeners();
  }

  //add friend to the databsae
  // void addOrganization (Organization organization) async {
  //   // _friends.add(friend);
  //   // notifyListeners();
  //   String message = await firebaseService.addOrganization(organization.toJson(organization));
  //   print(message);
  //   notifyListeners();
  // }

  // //delete friend from the datbase
  // void deleteFriend(String id) async{
  //   // _friends.remove(friend);
  //   // notifyListeners();
  //   await firebaseService.deleteTodo(id);
  //   notifyListeners();
  // }

  // //edits info of a friend with the given index from the databse
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

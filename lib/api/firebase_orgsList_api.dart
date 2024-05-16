import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseTodoAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllOrganizations() {
    return db.collection("organizations").snapshots();
  }

  // Future<String> addDonation(Map<String, dynamic> donation) async {
  //   try {
  //     await db.collection("donations").add(donation);

  //     return "Successfully added!";
  //   } on FirebaseException catch (e) {
  //     return "Error in ${e.code}: ${e.message}";
  //   }
  // }

  // Future<String> deleteTodo(String id) async {
  //   try {
  //     await db.collection("Friend List").doc(id).delete();

  //     return "Successfully deleted!";
  //   } on FirebaseException catch (e) {
  //     return "Error in ${e.code}: ${e.message}";
  //   }
  // }

  // Future<String> editTodo(String nickname, String age, bool status, double happiness, String superpower, String motto, String id) async {
  //   try {
  //     await db.collection("Friend List").doc(id).update(
  //       {'nickname': nickname,
  //       'age': age,
  //       'status': status,
  //       'happiness': happiness,
  //       'superpower': superpower,
  //       'motto': motto},);

  //     return "Successfully edited!";
  //   } on FirebaseException catch (e) {
  //     return "Error in ${e.code}: ${e.message}";
  //   }
  // }
}
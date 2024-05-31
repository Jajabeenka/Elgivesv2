import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseTodoAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllDonations() {
    return db.collection("donations").snapshots();
  }

  Future<String> addDonation(Map<String, dynamic> donation) async {
    try {
      await db.collection("donations").add(donation);

      return "Successfully added!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }

  Future<String> editStatus(int donationId, String status) async {
    try {
      QuerySnapshot snapshot = await db.collection("donations").where('donationId', isEqualTo: donationId).get();
      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference.update({'status': status});
        return "Successfully updated!";
      } else {
        return "Donation not found!";
      }
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }

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
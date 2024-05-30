import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseTodoAPI {

  //get collection of donation drives
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllDrives() {
    return db.collection("drive").snapshots();
  }

  //CREATE: add a donation drive
  Future<String> addDrive(Map<String, dynamic> donation) async {
    try {
      await db.collection("donations").add(donation);

      return "Successfully added!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }

  //READ: get donation drive from database

  //UPDATE: update donation drive given a doc id

  //DELETE: delete donation drive given a doc id
}
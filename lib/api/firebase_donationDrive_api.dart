import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseTodoAPI {

  //get collection of donation drives
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllDrives() {
    return db.collection("drive").snapshots();
  }

  //CREATE: add a donation drive
  Future<String> addDrive(Map<String, dynamic> drive) async {
    try {
      await db.collection("drive").add(drive);

      return "Successfully added!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }

  //READ: get donation drive from database

  //UPDATE: update donation drive given a doc id
  Future<String> editDrive(String id, String driveName) async {
    try {
      await db.collection("drive").doc(id).update({"driveName": driveName});

      return "Successfully edited!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }

  //DELETE: delete donation drive given a doc id
  Future<String> deleteDrive(String id) async {
    try {
      await db.collection("drive").doc(id).delete();

      return "Successfully deleted!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }
}
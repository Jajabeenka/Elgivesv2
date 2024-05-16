import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseTodoAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllDonors() {
    return db.collection("donors").snapshots();
  }
}
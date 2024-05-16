// import 'package:cloud_firestore/cloud_firestore.dart';

// class FirebaseTodoAPI {
//   static final FirebaseFirestore db = FirebaseFirestore.instance;

// // todo = user
//   Future<String> addTodo(Map<String, dynamic> user) async {
//     try {
//       await db.collection("users").add(user);

//       return "Successfully added!";
//     } on FirebaseException catch (e) {
//       return "Error in ${e.code}: ${e.message}";
//     }
//   }



// }

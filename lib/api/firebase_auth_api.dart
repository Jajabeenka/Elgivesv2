import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elgivesv2/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthAPI {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  User? getUser() {
    return auth.currentUser;
  }

  Stream<User?> userSignedIn() {
    return auth.authStateChanges();
  }

  Future<bool?> getUserApprovalStatus() async {
    User? user = getUser();
    if (user == null) {
      return null;
    }

    try {
      DocumentSnapshot doc = await db.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return doc['status'];
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting approval status: $e");
      return null;
    }
  }

 Future<String?> signIn(String email, String password) async {
  try {
    await auth.signInWithEmailAndPassword(email: email, password: password);

    // Fetch user approval status after successful sign-in
    bool? userApprovalStatus = await getUserApprovalStatus();

    // Check approval status
    if (userApprovalStatus == false) {
      // If the account is not approved, sign the user out and return an error message
      await signOut();
      return "Your account is not approved.";
    }

    return "Successful!";
  } on FirebaseAuthException catch (e) {
    return e.message; // Simplified to return the error message directly
  } catch (e) {
    return "Error: $e";
  }
}


  Future<String?> signUp(
      String email,
      String password,
      String username,
      String name,
      String contactNumber,
      List<String> addresses,
      int accountType,
      bool status,
      String description,
      List<String> proof) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        AppUser newUser = AppUser(
          uid: credential.user!.uid,
          email: email,
          username: username,
          name: name,
          contactNumber: contactNumber,
          addresses: addresses,
          accountType: accountType,
          status: status,
          description: description,
          proof: proof,
        );

        // Save user information to Firestore
        try {
          Map<String, dynamic> userData = newUser.toJson();
          await db.collection("users").doc(credential.user!.uid).set(userData);
          return credential.user!.uid; // Now the user is successfully added to Firestore
        } on FirebaseException catch (e) {
          return "Error in Firestore: ${e.code}: ${e.message}";
          // Handle Firestore error
        }
      } else {
        return "Error: User authentication failed.";
      }
    } on FirebaseAuthException catch (e) {
      return e.message; // Return the FirebaseAuthException message directly
    } catch (e) {
      return "Error: $e";
    }
  }

  Future<String?> fetchEmail(String username) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await db
          .collection('users')
          .where("username", isEqualTo: username)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.get('email') as String?;
      } else {
        return null; // User not found
      }
    } catch (e) {
      print("Error fetching email: $e");
      return null;
    }
  }

  Future<bool> isUsernameUnique(String username) async {
    try {
      QuerySnapshot querySnapshot = await db
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      // Logging the size of the query result
      print('Query size: ${querySnapshot.size}');

      if (querySnapshot.size == 0) {
        return true;
      }
      return false;
    } catch (e) {
      // Logging the error
      print('Error in isUsernameUnique: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}

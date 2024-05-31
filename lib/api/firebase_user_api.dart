import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elgivesv2/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// This class provides methods for interacting with user data stored in Cloud Firestore.

class FirebaseUserAPI {
  /// Cloud Firestore instance.
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  /// Firebase Authentication instance.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Retrieves a stream of all users stored in Firestore.
  ///
  /// Returns a stream of lists of [AppUser] objects representing the users.
  Stream<List<AppUser>> fetchUsers() {
    try {
      return db.collection('users').snapshots().map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return AppUser.fromJson(doc.data());
        }).toList();
      });
    } catch (e) {
      print("Error getting Users: $e");
      return Stream.error("Error getting Users: $e");
    }
  }

  /// Retrieves a stream of users filtered by account type and approval status.
  ///
  /// Returns a stream of lists of [AppUser] objects representing the filtered users.
  Stream<List<AppUser>> fetchUsersByAccountType(
      int accountType, bool approvalStatus) {
    try {
      return db
          .collection('users')
          .where('accountType', isEqualTo: accountType)
          .where('status', isEqualTo: approvalStatus)
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return AppUser.fromJson(doc.data());
        }).toList();
      });
    } catch (e) {
      print("Error getting Users: $e");
      return Stream.error("Error getting Users: $e");
    }
  }

  /// Updates user details in Firestore.
  ///
  /// Returns `null` if the update is successful, otherwise returns an error message.
  Future<String?> updateUser(String id, Map<String, dynamic> details) async {
    try {
      await db.collection('users').doc(id).update(details);
    } catch (e) {
      print("Error updating user: $e");
      return "Error updating user: $e";
    }
    return null;
  }

  /// Retrieves the ID of the current user.
  ///
  /// Returns the user ID if available, otherwise returns `null`.
  Future<String?> fetchID() async {
    try {
      User? user = _auth.currentUser;
      return user?.uid;
    } catch (e) {
      print("Error getting current user ID: $e");
      return null;
    }
  }

  /// Checks if a username is unique in Firestore.
  ///
  /// Returns `true` if the username is unique, otherwise returns `false`.
  Future<bool> usernameChecker(String username) async {
    try {
      QuerySnapshot querySnapshot = await db
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      if (querySnapshot.size == 0) {
        return true;
      }
      return false;
    } catch (e) {
      print('$e');
      return false;
    }
  }

  /// Retrieves account information for a given user ID.
  ///
  /// Returns an [AppUser] object representing the account info if available, otherwise returns `null`.
  Future<AppUser?> getAccountInfo(String id) async {
    try {
      DocumentSnapshot doc = await db.collection('users').doc(id).get();
      if (doc.data() != null) {
        return AppUser.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      print("Error getting account info: $e");
      return null;
    } catch (e) {
      print("Unexpected error: $e");
      return null;
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elgivesv2/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// This class provides methods for authentication and user management using Firebase Authentication and Cloud Firestore.

class FirebaseAuthAPI {
  /// Firebase Authentication instance.
  static final FirebaseAuth auth = FirebaseAuth.instance;

  /// Cloud Firestore instance.
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  /// Retrieves the currently signed-in user.
  ///
  /// Returns `null` if no user is signed in.
  User? getUser() {
    return auth.currentUser;
  }

  /// Provides a stream of changes to the authentication state.
  ///
  /// Returns a stream of [User] objects representing the current authentication state.
  Stream<User?> userSignedIn() {
    return auth.authStateChanges();
  }

  /// Retrieves the approval status of the current user.
  ///
  /// Returns `true` if the user is approved, `false` if not approved, and `null` if the user is not signed in.
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

  /// Signs in a user with the provided email and password.
  ///
  /// Returns a success message if the sign-in is successful, otherwise returns an error message.
  Future<String?> signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return "Successful!";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email' || e.code == 'invalid-credential' || e.code == 'wrong-password' || e.code == 'user-not-found') {
        return e.message;
      } else {
        return "Failed at ${e.code}: ${e.message}";
      }
    }
  }

  /// Signs up a new user with the provided information.
  ///
  /// Returns the user's UID if the sign-up is successful, otherwise returns an error message.
  Future<String?> signUp(
      String email,
      String password,
      String username,
      String name,
      String contactNumber,
      String description,
      List<String> addresses,
      int accountType,
      bool status) async {
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
          description: description,
          contactNumber: contactNumber,
          addresses: addresses,
          accountType: accountType,
          status: status,
        );

        // Save user information to Firestore
        try {
          Map<String, dynamic> userData = newUser.toJson(newUser);
          await db.collection("users").doc(credential.user!.uid).set(userData);
          return credential.user!.uid;
        } on FirebaseException catch (e) {
          return "Error in Firestore: ${e.code}: ${e.message}";
        }
      } else {
        return "Error: User authentication failed.";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'Error: The account already exists for that email.';
      } else if (e.code == 'weak-password') {
        return 'Error: Weak password';
      }
    } catch (e) {
      return "Error: $e";
    }

    return "Error";
  }

  /// Fetches the email associated with a given username from Firestore.
  ///
  /// Returns the email address if the username is found, otherwise returns `null`.
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

  /// Checks if a username is unique in the Firestore database.
  ///
  /// Returns `true` if the username is unique, otherwise returns `false`.
  Future<bool> isUsernameUnique(String username) async {
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
      print('Error in isUsernameUnique: $e');
      return false;
    }
  }

  /// Signs out the current user.
  ///
  /// This method clears the authentication state.
  Future<void> signOut() async {
    await auth.signOut();
  }
}

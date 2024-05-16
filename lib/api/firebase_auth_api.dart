import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ito yung class
class FirebaseAuthAPI {
  // instantiate a new instance
  static final FirebaseAuth auth = FirebaseAuth.instance;

// lahat ng details ng LOGGED IN user andito na
  User? getUser() {
    return auth.currentUser;
  }

// chinecheck kung may naka sign in o wala
  Stream<User?> userSignedIn() {
    return auth.authStateChanges();
  }

  Future<String?> signIn(String email, String password) async {
    // UserCredential credential;
    try {
       await auth.signInWithEmailAndPassword(
          email: email, password: password);
          return "";
//let's print the object returned by signInWithEmailAndPassword
//you can use this object to get the user's id, email, etc.
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
//possible to return something more useful
//than just print an error message to improve UI/UX
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<void> signUp(  String name,
  String username,
  String email,
  String password,
  List<String> addresses,
  String contactNumber,) async {
    UserCredential credential;
    try {
      // papasa lang paggawa method
      credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password, 
      );
      // add fname and lname
    await FirebaseFirestore.instance.collection('donors').doc(credential.user!.uid).set({
      'name': name, // Store user's full name
        'username': username,
        'email': email,
        'addresses': addresses, // Store user's addresses as a list
        'contactNumber': contactNumber,
    });

//let's print the object returned by signInWithEmailAndPassword
//you can use this object to get the user's id, email, etc.\
      print(credential);
    } on FirebaseAuthException catch (e) {
//possible to return something more useful
//than just print an error message to improve UI/UX
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }else if (e.code == 'invalid-email') {
        print('Invalid email address');
      }
    } catch (e) {
      print(e);
    }
  }

Future<void> orgSignUp(
  String organizationName,
  String description,
  String email,
  String password,
  String contactNumber,
  String proofOfLegitimacy,
) async {
  try {
    // Create user with email and password
    UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Store user information in Firestore under 'organizations' collection
    await FirebaseFirestore.instance.collection('organizations').doc(credential.user!.uid).set({
      'organizationName': organizationName,
      'description': description,
      'email': email,
      'contactNumber': contactNumber,
      'proofOfLegitimacy': proofOfLegitimacy,
    });

    // Print the user credential object for debugging or tracking purposes
    print(credential);
  } on FirebaseAuthException catch (e) {
    // Handle specific FirebaseAuth errors
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    } else if (e.code == 'invalid-email') {
      print('Invalid email address');
    } else {
      print('FirebaseAuthException occurred: $e');
    }
  } catch (e) {
    // Handle other exceptions
    print('Error occurred during organization sign-up: $e');
  }
}

Future<void> signOut() async {
  await auth.signOut();
}
}


// kung magkaiba ang iaaccess 
// authentication only
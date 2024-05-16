import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../api/firebase_auth_api.dart';

class UserAuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  late Stream<User?> _uStream;

  UserAuthProvider() {
    authService = FirebaseAuthAPI();
    fetchAuthentication();
  }

  Stream<User?> get userStream => _uStream;
  User? get user => authService.getUser();

  void fetchAuthentication() {
    _uStream = authService.userSignedIn();
    notifyListeners();
  }

// modified
Future<void> signUp(
  String name,
  String username,
  String email,
  String password,
  List<String> addresses,
  String contactNumber,
) async {
  await authService.signUp(
    name,
    username,
    email,
    password,
    addresses,
    contactNumber,
  );
  notifyListeners();
}

Future<void> orgSignUp(
  String organizationName,
  String description,
  String contactInformation,
  String email,
  String password,
  String proofOfLegitimacy,
) async {
  await authService.orgSignUp(
organizationName,
   description,
   contactInformation,
   email,
   password,
   proofOfLegitimacy,
  );
  notifyListeners();
}

  Future<void> signIn(String email, String password) async {
    await authService.signIn(email, password);
    notifyListeners();
  }

  Future<void> signOut() async {
    await authService.signOut();
    notifyListeners();
  }
}

import 'dart:async';
import 'package:elgivesv2/api/firebase_auth_api.dart';
import 'package:elgivesv2/api/firebase_user_api.dart';
import 'package:elgivesv2/models/user.dart';
import 'package:elgivesv2/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserAuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  late Stream<User?> _authStream;
  bool? _userApprovalStatus;
  AppUser? _accountInfo;
  Stream<List<AppUser>>? _dbStream;
  bool unique = false;

  UserAuthProvider() {
    authService = FirebaseAuthAPI();
    _initializeStreams();
  }

  void refresh() {
    _getAccountInfo();
  }

  Stream<User?> get userStream => _authStream;
  User? get user => authService.getUser();
  bool? get userApprovalStatus => _userApprovalStatus;
  AppUser? get accountInfo => _accountInfo;

  void _initializeStreams() {
    _authStream = authService.userSignedIn();
    notifyListeners();

    _authStream.listen((user) {
      refresh();
    });

    _dbStream = FirebaseUserAPI().fetchUsers();
    _dbStream!.listen((users) {
      refresh();
    });
  }

  String? _email;

  String? get email => _email;

  Future<void> fetchEmail(String username) async {
    _email = await authService.fetchEmail(username);
    notifyListeners();
  }

  Future<void> _getAccountInfo() async {
    if (user == null) {
      return;
    }
    _accountInfo = await UserProvider().getAccountInfo(user!.uid);
    _userApprovalStatus = _accountInfo?.status;
    notifyListeners();
  }

  Future<String?> signUp(
      String email,
      String password,
      String username,
      String name,
      String contactNo,
      String description,
      List<String> address,
      int accountType,
      bool isApproved) async {
    String? uid = await authService.signUp(email, password, username, name,
        contactNo, description, address, accountType, isApproved);
    notifyListeners();
    return uid;
  }

  Future<String?> signInWithUsername(String username, String password) async {
    // Fetch the email associated with the username
    await fetchEmail(username);

    if (_email == null) {
      return "Username not found.";
    }

    // Attempt to sign in with the fetched email
    String? message = await signIn(_email!, password);

    return message;
  }

  Future<String?> signIn(String email, String password) async {
  

      // Check approval status
      if (_userApprovalStatus == true) {
        return "Your account is not approved.";
      }else{
  // Attempt to sign in
    String? message = await authService.signIn(email, password);

    if (message != null) {
      // Fetch user account info after successful sign-in
      await _getAccountInfo();
      }

      notifyListeners();
      return message;
    }

  }

  Future<bool> isUsernameUnique(String username) async {
    unique = await authService.isUsernameUnique(username);
    notifyListeners();
    return unique;
  }

  Future<void> signOut() async {
    await authService.signOut();
    _accountInfo = null;
    notifyListeners();
  }
}

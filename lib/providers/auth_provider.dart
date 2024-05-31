import 'package:elgivesv2/api/firebase_auth_api.dart';
import 'package:elgivesv2/api/firebase_user_api.dart';
import 'package:elgivesv2/models/user.dart';
import 'package:elgivesv2/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// This class provides authentication and user data management functionality for the application.
class UserAuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  late Stream<User?> _authStream;
  bool? _userApprovalStatus;
  AppUser? _accountInfo;
  Stream<List<AppUser>>? _dbStream;
  bool unique = false;

  /// Constructor for initializing [UserAuthProvider] and setting up necessary streams.
  UserAuthProvider() {
    authService = FirebaseAuthAPI();
    _initializeStreams();
  }

  /// Refreshes user and account information.
  void refresh() {
    _getAccountInfo();
  }

  /// Retrieves the authentication stream.
  Stream<User?> get userStream => _authStream;

  /// Retrieves the current user.
  User? get user => authService.getUser();

  /// Retrieves the approval status of the current user.
  bool? get userApprovalStatus => _userApprovalStatus;

  /// Retrieves the account information of the current user.
  AppUser? get accountInfo => _accountInfo;

  /// Initializes authentication and database streams.
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

  /// Retrieves the email associated with a given username.
  String? get email => _email;

  /// Fetches the email associated with a given username from the database.
  Future<void> fetchEmail(String username) async {
    _email = await authService.fetchEmail(username);
    notifyListeners();
  }

  /// Retrieves the account information of the current user.
  Future<void> _getAccountInfo() async {
    if (user == null) {
      return;
    }
    _accountInfo = await UserProvider().getAccountInfo(user!.uid);
    _userApprovalStatus = _accountInfo?.status;
    notifyListeners();
  }

  /// Registers a new user with the provided information.
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

  /// Signs in a user with the provided username and password.
  ///
  /// If the user's account is not approved, returns an error message.
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

  /// Signs in a user with the provided email and password.
  ///
  /// If the user's account is not approved, returns an error message.
  Future<String?> signIn(String email, String password) async {
    // Check approval status
    if (_userApprovalStatus == true) {
      return "Your account is not approved.";
    } else {
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

  /// Checks if a username is unique in the database.
  ///
  /// Returns `true` if the username is unique, otherwise returns `false`.
  Future<bool> isUsernameUnique(String username) async {
    unique = await authService.isUsernameUnique(username);
    notifyListeners();
    return unique;
  }

  /// Signs out the current user.
  ///
  /// Clears the authentication state and account information.
  Future<void> signOut() async {
    await authService.signOut();
    _accountInfo = null;
    notifyListeners();
  }
}

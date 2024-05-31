import 'dart:async';
import 'package:elgivesv2/models/user.dart';
import 'package:flutter/material.dart';
import '../api/firebase_user_api.dart';

/// A provider class that manages user data and interaction with Firebase.
class UserProvider with ChangeNotifier {
  /// Firebase service instance for fetching and updating user data.
  late FirebaseUserAPI fbService;

  /// Stream of users from the database.
  Stream<List<AppUser>>? _dbStream;

  /// Stream of donor users.
  late Stream<List<AppUser>> _donorStream = Stream.empty();

  /// Stream of approved organization users.
  late Stream<List<AppUser>> _orgStream = Stream.empty();

  /// Stream of pending organization users.
  late Stream<List<AppUser>> _pendingOrgStream = Stream.empty();

  /// Getter for the stream of donor users.
  Stream<List<AppUser>> get donorStream => _donorStream;

  /// Getter for the stream of approved organization users.
  Stream<List<AppUser>> get orgStream => _orgStream;

  /// Getter for the stream of pending organization users.
  Stream<List<AppUser>> get pendingOrgStream => _pendingOrgStream;

  /// Account type identifiers.
  final int adminAccount = 1, donorAccount = 2, organizationAccount = 3;

  /// Currently selected user.
  AppUser? _selectedUser;

  /// Getter for the currently selected user.
  AppUser? get selectedUser => _selectedUser;

  /// Flag to indicate if the username is unique.
  bool unique = false;

  /// Constructor initializes the Firebase service and starts listening to the user stream.
  UserProvider() {
    fbService = FirebaseUserAPI();
    _dbStream = fbService.fetchUsers();
    _dbStream?.listen((users) {
      refresh();
    });

    fetchDonors();
    fetchOrganizations();
    fetchPendingOrganizations();
  }

  /// Refreshes the data of the selected user.
  void refresh() {
    if (_selectedUser != null) getAccountInfo(_selectedUser!.uid);
  }

  /// Fetches users by account type and approval status, and sorts them by name.
  void _fetchUsersByType(int accountType, bool approvalStatus) {
    try {
      var newStream = fbService.fetchUsersByAccountType(accountType, approvalStatus);

      var sortedStream = newStream.map((snapshot) {
        var docs = List<AppUser>.from(snapshot);
        docs.sort((a, b) => a.name.compareTo(b.name));
        return docs;
      });

      switch (accountType) {
        case 2:
          _donorStream = sortedStream;
          break;
        case 3:
          if (approvalStatus) {
            _orgStream = sortedStream;
          } else {
            _pendingOrgStream = sortedStream;
          }
          break;
        default:
          break;
      }

      notifyListeners();
    } catch (e) {
      print('Error fetching users: $e');
      notifyListeners();
    }
  }

  /// Fetches donors from the database.
  void fetchDonors() {
    _fetchUsersByType(donorAccount, true);
  }

  

  /// Fetches approved organizations from the database.
  void fetchOrganizations() {
    _fetchUsersByType(organizationAccount, true);
  }

  /// Fetches pending organizations from the database.
  void fetchPendingOrganizations() {
    _fetchUsersByType(organizationAccount, false);
  }

  /// Fetches admins from the database.
  void fetchAdmins() {
    _fetchUsersByType(adminAccount, false);
  }

  /// Retrieves account information for a user by their ID.
  Future<AppUser?> getAccountInfo(String? id) async {
    if (id == null) {
      _selectedUser = null;
      notifyListeners();
      return _selectedUser;
    }

    _selectedUser = await fbService.getAccountInfo(id);
    notifyListeners();
    return _selectedUser;
  }

  /// Checks if a username is unique.
  Future<bool> usernameChecker(String username) async {
    unique = await fbService.usernameChecker(username);
    notifyListeners();
    return unique;
  }

  /// Updates user details in the database.
  Future<String?> updateUser(String id, AppUser details) async {
    String? message = await fbService.updateUser(id, details.toJson(details));
    notifyListeners();
    return message;
  }
}

import 'dart:convert';

class AppUser {
  final String uid;
  final String email;
  final String username;
  final String name;
  final String contactNumber;
  final List<String> addresses;
  final int accountType;
  final bool status;
  final String description;
  final List<String> proof;

  AppUser({
    required this.uid,
    required this.email,
    required this.username,
    required this.name,
    required this.contactNumber,
    required this.addresses,
    required this.accountType,
    required this.status,
    required this.description,
    required this.proof,
  });

  AppUser duplicate({
    String? uid,
    String? email,
    String? username,
    String? name,
    String? contactNumber,
    List<String>? addresses,
    int? accountType,
    bool? status,
    String? description,
    List<String>? proof,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      name: name ?? this.name,
      contactNumber: contactNumber ?? this.contactNumber,
      addresses: addresses ?? this.addresses,
      accountType: accountType ?? this.accountType,
      status: status ?? this.status,
      description: description ?? this.description,
      proof: proof ?? this.proof,
    );
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'],
      email: json['email'],
      username: json['username'],
      name: json['name'],
      contactNumber: json['contactNumber'],
      addresses: List<String>.from(json['addresses']),
      accountType: json['accountType'],
      status: json['status'] ?? false,
      description: json['description'] ?? '',
      proof: List<String>.from(json['proof'] ?? []),
    );
  }

  static List<AppUser> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<AppUser>((dynamic d) => AppUser.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'name': name,
      'contactNumber': contactNumber,
      'addresses': addresses,
      'accountType': accountType,
      'status': status,
      'description': description,
      'proof': proof,
    };
  }
}

import 'dart:convert';

class AppUser {
  final String email;
  final String uid;
  final String username;
  final String name;
  final String contactNumber;
  final List<String> addresses;
  final int accountType;
  final bool status;

  final bool isOpen;
  final String desc;
  final List<String> proofOfLegitimacy;


  AppUser({
    required this.email,
    required this.uid,
    required this.username,
    required this.name,
    required this.contactNumber,
    required this.addresses,
    required this.accountType,
    required this.status,

    // additional fields for organizations
    this.isOpen = false,
    this.desc = '',
    this.proofOfLegitimacy = const [],

  });

   AppUser copyWith({
    String? email,
    String? uid,
    String? username,
    String? name,
    String? contactNumber,
    List<String>? addresses,
    int? accountType,
    bool? status,
    bool? isOpen,
    String? desc,
    List<String>? proofOfLegitimacy,

  }) {
    return AppUser(
      email: email ?? this.email,
      uid: uid ?? this.uid,
      username: username ?? this.username,
      name: name ?? this.name,
      contactNumber: contactNumber ?? this.contactNumber,
      addresses: addresses ?? this.addresses,
      accountType: accountType ?? this.accountType,
      status: status ?? this.status,
      isOpen: isOpen ?? this.isOpen,
      desc: desc ?? this.desc,
      proofOfLegitimacy: proofOfLegitimacy ?? this.proofOfLegitimacy,
    );
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
  return AppUser(
    uid: json['uid'] ?? '',
    email: json['email'] ?? '',
    username: json['username'] ?? '',
    name: json['name'] ?? '',
    contactNumber: json['contactNumber'] ?? '',
    addresses: List<String>.from(json['addresses'] ?? []),
    accountType: json['accountType'] ?? 0,
    status: json['status'] ?? false,
    isOpen: json['isOpen'] ?? false,
    desc: json['desc'] ?? '',
    proofOfLegitimacy: List<String>.from(json['proofOfLegitimacy'] ?? []),
  );
}

  static List<AppUser> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<AppUser>((dynamic d) => AppUser.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(AppUser appUser) {
    return {
      'email': email,
      'uid': uid,
      'username': username,
      'name': name,
      'contactNumber': contactNumber,
      'addresses': addresses,
      'accountType': accountType,
      'status': status,
      'isOpen': isOpen,
      'desc': desc,
      'proofOfLegitimacy':proofOfLegitimacy,
    };
  }
}


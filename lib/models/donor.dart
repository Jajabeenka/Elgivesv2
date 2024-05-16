
import 'dart:convert';

class Donor {
  String name;   //string,  since uid of user is a string
  String username;
  List<String> addresses;
  String contactNumber;

  Donor({
    required this.name,
    required this.username,
    required this.addresses,
    required this.contactNumber,
  });

  // Factory constructor to instantiate object from json format
  factory Donor.fromJson(Map<String, dynamic> json) {
    return Donor(
      name: json['name'],
      addresses: List<String>.from(json['addresses']),
      username: json['username'],
      contactNumber: json['contactNumber'],
    );
  }

  static List<Donor> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Donor>((dynamic d) => Donor.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Donor donor) {
    return {
      'name': donor.name,
      'addresses': donor.addresses,
      'username': donor.username,
      'contactNumber': donor.contactNumber,
    };
  }
}

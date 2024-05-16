
import 'dart:convert';

class Organization {
  String name;  
  String description;
  bool status;

  Organization({
    required this.name,
    required this.description,
    required this.status,
  });

  // Factory constructor to instantiate object from json format
  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      name: json['name'],
      description: json['description'],
      status: json['status'],
    );
  }

  static List<Organization> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Organization>((dynamic d) => Organization.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Organization organization) {
    return {
      'name': organization.name,
      'description': organization.description,
      'status': organization.status,
    };
  }
}

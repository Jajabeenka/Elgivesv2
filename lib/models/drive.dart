import 'dart:convert';

class Drive {
  final int driveId;
  String? id;
  String driveName;
  String? description;
  String? orgId;
  List<String>? donationList;
  //final List<String> donations;

  Drive({
    required this.driveId,
    this.id,
    required this.driveName,
    this.description,
    this.orgId,
    this.donationList
  });

  // Factory constructor to instantiate object from json format
  factory Drive.fromJson(Map<String, dynamic> json) {
    return Drive(
      driveId: json['driveId'],
      id: json['id'],
      driveName: json['driveName'],
      description: json['description'],
      orgId: json['orgId'],
      donationList: json['donationList']
    );
  }

  static List<Drive> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Drive>((dynamic d) => Drive.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Drive drive) {
    return {
      'driveId': drive.driveId,
      'driveName': drive.driveName,
      'description': drive.description,
      'orgId': drive.orgId,
      'donationList': drive.donationList
    };
  }

}
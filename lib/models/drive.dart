import 'dart:convert';

class Drive {
  final int driveId;
  String driveName;
  //final List<String> donations;

  Drive({
    required this.driveId,
    required this.driveName,
  });

  // Factory constructor to instantiate object from json format
  factory Drive.fromJson(Map<String, dynamic> json) {
    return Drive(
      driveId: json['driveId'],
      driveName: json['driveName'],
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
    };
  }

}
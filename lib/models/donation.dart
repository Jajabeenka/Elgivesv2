import 'dart:convert';

class Donation {
  final List<String> categories;
  final String pickupOrDropOff;
  final String weight;
  final String? photo;
  final DateTime dateTime;
  final String addresses;
  final String contactNumber;
  final String status;
  final String? userId;
  final int donationId;
  final String? orgId;

  Donation({
    required this.categories,
    required this.pickupOrDropOff,
    required this.weight,
    this.photo,
    required this.dateTime,
    required this.addresses,
    required this.contactNumber,
    required this.status,
    required this.userId,
    required this.donationId,
    required this.orgId,
  });

  // Factory constructor to instantiate object from json format
  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      categories: List<String>.from(json['categories'] ?? []),
      pickupOrDropOff: json['pickupOrDropOff'] ?? '',
      weight: json['weight'] ?? '',
      photo: json['photo'],
      dateTime: DateTime.parse(json['dateTime'] ?? DateTime.now().toString()),
      addresses: json['addresses'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      status: json['status'] ?? '',
      userId: json['userId'],
      donationId: json['donationId'],
      orgId: json['orgId']
    );
  }

  static List<Donation> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Donation>((dynamic d) => Donation.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Donation donation) {
    return {
      'categories': donation.categories,
      'pickupOrDropOff': donation.pickupOrDropOff,
      'weight': donation.weight,
      'photo': donation.photo,
      'dateTime': donation.dateTime.toString(),
      'addresses': donation.addresses,
      'contactNumber': donation.contactNumber,
      'status': donation.status,
      'userId': donation.userId,
      'donationId' : donation.donationId,
      'orgId' : donation.orgId
    };
  }

Donation copyWith({
    List<String>? categories,
    String? pickupOrDropOff,
    String? weight,
    String? photo,
    DateTime? dateTime,
    String? addresses,
    String? contactNumber,
    String? status,
    String? userId,
    int? donationId,
    String? orgId,
  }) {
    return Donation(
      categories: categories ?? this.categories,
      pickupOrDropOff: pickupOrDropOff ?? this.pickupOrDropOff,
      weight: weight ?? this.weight,
      photo: photo ?? this.photo,
      dateTime: dateTime ?? this.dateTime,
      addresses: addresses ?? this.addresses,
      contactNumber: contactNumber ?? this.contactNumber,
      status: status ?? this.status,
      userId: userId ?? this.userId,
      donationId: donationId ?? this.donationId,
      orgId: orgId ?? this.orgId,
    );
  }

}

// DateTime combineDateAndTime(DateTime date, TimeOfDay time) {
//   return DateTime(
//     date.year,
//     date.month,
//     date.day,
//     time.hour,
//     time.minute,
//   );
// }





  // //converts a json format object to a friend object
  // factory Friend.fromJson(Map<String, dynamic> json) {
  //   return Friend(
  //     name: json['name'],
  //     nickname: json['nickname'],
  //     age: json['age'],
  //     status: json['status'],
  //     happiness: (json['happiness']).toDouble(),
  //     superpower: json['superpower'],
  //     motto: json['motto'],
  //   );
  // }

  // //array of json to list of friends
  // static List<Friend> fromJsonArray(String jsonData) {
  //   final Iterable<dynamic> data = jsonDecode(jsonData);
  //   return data.map<Friend>((dynamic d) => Friend.fromJson(d)).toList();
  // }

  // // Friend object to JSON format
  // Map<String, dynamic> toJson(Friend friend) {
  //   return {
  //     'name': friend.name,
  //     'nickname': friend.nickname,
  //     'age': friend.age,
  //     'status': friend.status,
  //     'happiness': friend.happiness,
  //     'superpower': friend.superpower,
  //     'motto': friend.motto,
  //   };
  // }
// }

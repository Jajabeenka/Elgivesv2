import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class StoreData {
  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    Reference ref = _storage.ref().child(childName);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> saveData({required Uint8List file, required int index}) async {
    String resp = 'Some Error Occured';
    try {
      String imageURL = await uploadImageToStorage('DonationImage_$index', file);
      // await _firestore.collection('donationImages').add({
      //   'imageLink': imageURL,
      // });
      resp = imageURL;
    } catch (e) {
      resp = e.toString();
    }
    return resp;
  }
}
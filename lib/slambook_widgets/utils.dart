import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();   //image picker allow you to pick image in your gallery or camera
  XFile? _file = await _imagePicker.pickImage(source: source); //contains info about the asset like file ype etc

  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No Image Selected');
}
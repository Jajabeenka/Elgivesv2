import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:math';
import 'dart:math';

import 'package:elgivesv2/models/donor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../provider/add_image.dart';
import '../provider/donation_provider.dart';
import '../providers/auth_provider.dart';
import '../slambook_widgets/time.dart';
import '../slambook_widgets/utils.dart';
import '../slambook_widgets/weight.dart';
import '../slambook_widgets/mode.dart';
import '../slambook_widgets/address.dart';
import '../slambook_widgets/date.dart';
import '../slambook_widgets/item.dart';
import '../slambook_widgets/drawer.dart';
import '../slambook_widgets/contactNum.dart';
import '../models/donation.dart'; // Import the Friend class
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

class FormSample extends StatefulWidget {
  final String orgName;
  final String orgDescri;
  final bool orgStatus;
  final String orgId;
  final String userId;

  const FormSample({
    required this.orgName,
    required this.orgDescri,
    required this.orgStatus,
    required this.orgId,
    required this.userId,
    Key? key,
  }) : super(key: key);

  @override
  State<FormSample> createState() => _FormSampleState();
}

class _FormSampleState extends State<FormSample> {
  final _formKey = GlobalKey<FormState>();
  Uint8List? _image;

  bool showText = false;
  List<String> categories = [];
  String pickupOrDropOff = "Pickup";
  String weight = "";
  String? photo;
  DateTime dateTime = DateTime.now();
  String addresses = "";
  String contact = "";
  String status = "Pending";
  int donationId = 0;

  int generateUniqueId() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(900) + 100; // Generate a random number between 100 and 999
    return int.parse('${now}${random}');
  }

  void initState() {
    super.initState();
    donationId = generateUniqueId();  // Set once during initialization
  }

  void resetFields() {
  setState(() {
    categories = []; 
    pickupOrDropOff = "Pickup"; 
    weight = ""; 
    photo = null; 
    dateTime = DateTime.now();
    addresses = ""; 
    contact = "";
    status = "Pending";
  });

  setState(() {
    pickDrop = Mode(
      initialValue: 'Pickup',
      onChanged: (initialValue) {
        setState(() {
          pickupOrDropOff = initialValue;
        });
      },
    );
  });
}

  void selectImage() async{
    Uint8List img = await pickImage(ImageSource.camera);
    setState(() {
      _image = img;
    }); 
  }
  
  late Mode pickDrop;
  String data = '';
  final GlobalKey _qrkey = GlobalKey();
  bool dirExists = false;
  late String externalDir;
  int i = 1;

Future<void> _captureandSavePng() async {
  try {
    // Request storage permission
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }

    // Handle MANAGE_EXTERNAL_STORAGE permission for Android 11 and above
    if (Platform.isAndroid && await Permission.manageExternalStorage.isGranted == false) {
      var manageStatus = await Permission.manageExternalStorage.status;
      if (!manageStatus.isGranted) {
        manageStatus = await Permission.manageExternalStorage.request();
      }
    }

    if (status.isGranted || (Platform.isAndroid && await Permission.manageExternalStorage.isGranted)) {
      RenderRepaintBoundary boundary = _qrkey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3);

      final whitePaint = Paint()..color = Colors.white;
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder,
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()));
      canvas.drawRect(
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
          whitePaint);
      canvas.drawImage(image, Offset.zero, Paint());
      final picture = recorder.endRecording();
      final img = await picture.toImage(image.width, image.height);
      ByteData? byteData = await img.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Get the Downloads directory
      final downloadsDirectory = await getExternalStorageDirectory();
      final downloadDir = '${downloadsDirectory!.parent.parent.parent.parent.path}/Download';

      externalDir = '$downloadDir/QR_Code';

      String filename = 'qr_code';
      int i = 1;
      while (await File('$externalDir/$filename.png').exists()) {
        filename = 'qr_code_$i';
        i++;
      }

      dirExists = await Directory(externalDir).exists();
      if (!dirExists) {
        await Directory(externalDir).create(recursive: true);
        dirExists = true;
      }

      final file = await File('$externalDir/$filename.png').create();
      await file.writeAsBytes(pngBytes);

      if (!mounted) return;
      const snackBar = SnackBar(
        content: Text("QR Code saved to Downloads/QR_Code!"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print('File saved to: $externalDir/$filename.png');
    } else {
      const snackBar = SnackBar(
        content: Text("Storage permission denied"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  } catch (e) {
    print('Error: $e');
    const snackBar = SnackBar(
      content: Text("Something went wrong!"),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}




Future<String> saveProfile() async{
  String? photoUrl;
  if (_image != null) {
    int index = generateUniqueId();
    photoUrl = await StoreData().saveData(file: _image!, index: index);
    // index++;
  }
  return photoUrl ?? '';
}

String? getUserId() {
  String userId = context.watch<UserAuthProvider>().user!.uid;
  if (userId != null) {
    return userId;
  }
  return null;
}
  @override
  Widget build(BuildContext context) {
    // donationId = generateUniqueId(); 
    DateTime initialDateTime = DateTime.now();
    pickDrop = Mode(
      initialValue: 'Pickup', 
      onChanged: (value) {
        setState(() {
          pickupOrDropOff = value; 
        });
      },
    );

    return Scaffold(
      // margin: EdgeInsets.all(20),
      drawer: DrawerWidget(text: "Organization"),
      appBar: AppBar(
        title: Text(
          "Donate Page",
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFC107),
          ),
        ),
        backgroundColor: Color(0xFF01563F),
        iconTheme: IconThemeData(color: Color(0xFF8D1436)),
      ),
      backgroundColor: Color(0xFF8D1436), 
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.business,
                    color: Colors.white,
                    size: 30, // Adjust the size as needed
                  ),
                  SizedBox(width: 8), // Add some spacing between the icon and text
                  Text(
                    widget.orgName,
                    style: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: Text(
                          'Organization Details',
                          style: TextStyle(
                            color: Color(0xFF01563F),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[200],
                          ),
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.business,
                                    color: Color(0xFF01563F),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Name: ${widget.orgName}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(
                                    Icons.description,
                                    color: Color(0xFF01563F),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Description: ${widget.orgDescri}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(
                                    widget.orgStatus ? Icons.check_circle : Icons.cancel,
                                    color: widget.orgStatus ? Colors.green : Colors.red,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Status: ${widget.orgStatus ? 'OPEN' : 'CLOSED'}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: widget.orgStatus ? Colors.green : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Color(0xFF01563F),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text(
                  'See More?',
                  style: TextStyle(
                    color: Color(0xFFFFC107),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Item(
                onChanged: (selectedOptions) {
                  setState(() {
                    categories = selectedOptions;
                  });
                },
                selectedOptions: categories,
              ),
              pickDrop,
              Weight((value) {
                setState(() {
                  weight = value;
                });
              }),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: _image != null
                          ? Image.memory(
                              _image!,
                              fit: BoxFit.cover,
                              width: 300,
                              height: 100,
                            )
                          : Center(
                              child: Icon(
                                Icons.person,
                                color: Color(0xFFFFC107),
                                size: 36,
                              ),
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFC107),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: selectImage,
                        icon: Icon(Icons.add_a_photo),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Date((date) {
                setState(() {
                  dateTime = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    dateTime.hour,
                    dateTime.minute,
                  );
                });
              }, dateTime: dateTime),
              Time((time) {
                setState(() {
                  dateTime = DateTime(
                    dateTime.year,
                    dateTime.month,
                    dateTime.day,
                    time.hour,
                    time.minute,
                  );
                });
              }, dateTime: dateTime),
              if (pickupOrDropOff == "Pickup")
              Address((addressList) {
                setState(() {
                  addresses = addressList;
                });
              },
              validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },),
              if (pickupOrDropOff == "Pickup")
              contactNumber((value) {
                setState(() {
                  contact = value;
                });
              }),
              
              SizedBox(height: 20,),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    backgroundColor:
                    // (dateTime.isBefore(DateTime.now()))
                        // ? Colors.grey.shade400
                         Color.fromARGB(255, 80, 196, 90),
                    // disabledBackgroundColor: Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: (dateTime.isBefore(DateTime.now()) || categories.isEmpty) 
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState?.save();
                            String? photoUrl;
                            photoUrl = await saveProfile();
                            Donation donation = Donation(
                              categories: categories,
                              pickupOrDropOff: pickupOrDropOff,
                              weight: weight,
                              photo: photoUrl,
                              dateTime: dateTime,
                              addresses: addresses,
                              contactNumber: contact,
                              status: "Pending",
                              userId: widget.userId,
                              donationId: donationId,
                              orgId: widget.orgId,
                            );
                            setState(() {
                              showText = true;
                            });
                            context.read<DonationProvider>().addDonation(donation);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Donation added!"),
                                duration: const Duration(seconds: 1, milliseconds: 100),
                              ),
                            );
                          }
                        },
                  icon: Icon(Icons.check, size: 25),
                  label: Text(
                    "DONATE",
                    style: TextStyle(
                      color: Color.fromARGB(255, 7, 6, 0),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              if (pickupOrDropOff == "Drop-off")
  Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          backgroundColor: Color.fromARGB(255, 80, 196, 90),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: (dateTime.isBefore(DateTime.now())) ? null : () {
          setState(() {
            data = "Status: $status \nDate Created: ${dateTime.toString()}\n donationId: ${donationId.toString()}";
          });
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'QR Code',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF01563F),
                        ),
                      ),
                      SizedBox(height: 16),
                      RepaintBoundary(
                        key: _qrkey,
                        child: QrImageView(
                          data: data,
                          version: QrVersions.auto,
                          size: 250,
                          gapless: true,
                          errorStateBuilder: (context, error) {
                            return const Center(
                              child: Text(
                                'Something went wrong!!!',
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      RawMaterialButton(
                        onPressed: _captureandSavePng,
                        fillColor: Color(0xFF8D1436),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        child: Text(
                          'Export',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
              icon: Icon(Icons.qr_code, size: 25),
              label: Text(
                "GENERATE QR CODE",
                style: TextStyle(
                  color: Color.fromARGB(255, 7, 6, 0),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
              Container(
                margin: EdgeInsets.all(10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      _formKey.currentState!.reset();
                      resetFields();
                      setState(() {
                        showText = false;
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Donation cancelled!"),
                          duration: const Duration(seconds: 1, milliseconds: 100),
                        ),
                      );
                    },
                    icon: Icon(Icons.cancel, size: 25),
                    label: Text(
                      "CANCEL",
                      style: TextStyle(
                        color: Color(0xFFFFC107),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

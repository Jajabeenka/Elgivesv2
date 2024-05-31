import 'package:elgivesv2/pages/addDrivePage.dart';
import 'package:elgivesv2/pages/profilePage.dart';
import 'package:elgivesv2/provider/donationDrive_provider.dart';
import 'package:elgivesv2/pages/profilePage.dart';
import 'package:elgivesv2/provider/donationDrive_provider.dart';
import 'package:elgivesv2/pages/userAdmin/admin/adminApprovalPage.dart';
import 'package:elgivesv2/pages/userAdmin/admin/adminDonors.dart';
import 'package:elgivesv2/provider/donor_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart'; 
import '../pages/donatePage.dart'; 
import '../pages/orgsPage.dart'; 
import '../provider/orgs_provider.dart'; 
import '../models/donation.dart'; 
import 'firebase_options.dart';
import 'provider/donation_provider.dart';
import 'pages/orgProfile.dart';
import 'pages/donationDrive.dart';
import 'provider/donationDrive_provider.dart';

import 'package:elgivesv2/pages/userAdmin/splash_screen.dart';
import 'providers/auth_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Permission.storage.request();

  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: ((context) => DonationProvider())),
        ChangeNotifierProvider(create: ((context) => OrganizationProvider())),
        ChangeNotifierProvider(create: ((context) => DonorProvider())),
        ChangeNotifierProvider(create: ((context) => DonationDriveProvider())),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EWAN Q PA',
      initialRoute: '/',
      routes: { 
        '/organizations': (context) => OrgsPage(),
        '/donorProfile': (context) => ProfilePage(),
        '/orgProfile': (context) => OrgProfile(),
        '/donationDrive': (context) => DonationDrive(),
        '/addDrivePage': (context) => AddDrivePage(),
        '/adminApproval': (context) => adminApproval(),
        '/adminDonors': (context) => DonorListWidget()

      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}



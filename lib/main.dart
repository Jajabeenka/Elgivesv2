import 'package:elgivesv2/pages/profilePage.dart';
import 'package:elgivesv2/pages/userAdmin/admin/adminApprovalPage.dart';
import 'package:elgivesv2/pages/userAdmin/admin/adminDonors.dart';
import 'package:elgivesv2/provider/donor_provider.dart';
import 'package:elgivesv2/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart'; 
import '../pages/donatePage.dart'; 
import '../pages/orgsPage.dart'; 
import '../provider/orgs_provider.dart'; 
import 'firebase_options.dart';
import 'provider/donation_provider.dart';

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
        ChangeNotifierProvider(create: ((context) => DonationProvider())),
        ChangeNotifierProvider(create: ((context) => OrganizationProvider())),
        ChangeNotifierProvider(create: ((context) => DonorProvider())),
        ChangeNotifierProvider(create: ((context) => UserAuthProvider())),
        ChangeNotifierProvider(create: (_) => UserProvider()),



      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EWAN Q PA',
      initialRoute: '/',
      routes: { 
        '/': (context) => const SplashScreen(),
        '/organizations': (context) => OrgsPage(),
        '/donorProfile': (context) => ProfilePage(),
        '/adminApproval': (context) => adminApproval(),
        '/adminDonors': (context) => DonorListWidget()

      },
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF00FF00, { // Green color for primary swatch
          50: Color(0xFFE0FFB0),
          100: Color(0xFFB3FF66),
          200: Color(0xFF80FF00),
          300: Color(0xFF66CC00),
          400: Color(0xFF4D9900),
          500: Color(0xFF00FF00),
          600: Color(0xFF00E600),
          700: Color(0xFF00CC00),
          800: Color(0xFF009900),
          900: Color(0xFF006600),
        }),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black), // Yellow text color
        ),
      ),
    );
  }
}

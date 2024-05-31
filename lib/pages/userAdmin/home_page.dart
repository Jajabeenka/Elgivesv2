
import 'package:elgivesv2/models/user.dart';
import 'package:elgivesv2/pages/orgsPage.dart';
import 'package:elgivesv2/pages/userAdmin/admin/adminApprovalPage.dart';
import 'package:elgivesv2/pages/userAdmin/admin/adminHomeScreen.dart';
import 'package:elgivesv2/pages/userAdmin/admin/admin_donors.dart';
import 'package:elgivesv2/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './signin_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppUser? user;

  @override
  Widget build(BuildContext context) {
    Stream<User?> userStream = context.watch<UserAuthProvider>().userStream;
    user = context.watch<UserAuthProvider>().accountInfo;

    return StreamBuilder<User?>(
      stream: userStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error!.toString()));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || user == null) {
          return const SignInPage();
        } else {
          
        
     if (user!.accountType == 1){
            return   HomeScreen();
          } else if (user!.accountType == 3){
            return  DonorListWidget();
          } else {
            return  HomeScreen();
          }

          }
        }
      
    );
  }
}



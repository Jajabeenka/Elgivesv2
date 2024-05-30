import 'package:elgivesv2/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminDrawerWidget extends StatefulWidget {
  final String? text;
  const AdminDrawerWidget({this.text, super.key});

  @override
  State<AdminDrawerWidget> createState() => _AdminDrawerWidgetState();
}

class _AdminDrawerWidgetState extends State<AdminDrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Text(
              "CMSC 23 Project",
              style: TextStyle(
                color: Color(0xFF01563F), // Forest Green for text
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            decoration: BoxDecoration(
              color: Color(0xFFFFC107), // Amber for header background
            ),
          ),
          ListTile(
            title: Text(
              "Pending Organizations",
              style: TextStyle(color: Color(0xFF01563F)), // Forest Green for text
            ),
            onTap: () {
              Navigator.popUntil(context, ModalRoute.withName("/adminApproval"));
            },
          ),
          ListTile(
            title: Text(
              "Donors List",
              style: TextStyle(color: Color(0xFF01563F)), // Forest Green for text
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/adminApproval");
            },
          ),
          ListTile(
            title: Text(
              'Logout',
              style: TextStyle(color: Color(0xFF8D1436)), // Crimson for text
            ),
            onTap: () {
              context.read<UserAuthProvider>().signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

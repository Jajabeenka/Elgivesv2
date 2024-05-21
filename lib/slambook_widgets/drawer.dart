import 'package:flutter/material.dart';

class DrawerWidget extends StatefulWidget {
  final String? text;
  const DrawerWidget({this.text, super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Text(
              "Exercise 5: Menu, routes, and Navigation",
              style: TextStyle(color:  Color.fromARGB(255, 168, 202, 235),
              fontSize: 18.0,
              fontWeight: FontWeight.bold,) , 
            ),
            decoration: BoxDecoration(color: Color.fromARGB(255, 5, 12, 49)),
          ),
          ListTile(
            title: Text("Organization", style: TextStyle(color: Color.fromARGB(255, 5, 12, 49))),
            onTap: () {
              Navigator.popUntil(context, ModalRoute.withName("/organizations"));
              // Navigator.pop(context);
              // Navigator.pushNamed(context, "/organizations");
            },
          ),
          ListTile(
            title: Text("Profile", style: TextStyle(color: Color.fromARGB(255, 5, 12, 49))),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/donorProfile");
            },
          ),
        ],
      ),
    );
  }
}


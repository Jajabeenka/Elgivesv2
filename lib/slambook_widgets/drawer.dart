import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';


class DrawerWidget extends StatefulWidget {
  final String? text;
  const DrawerWidget({this.text, super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  bool _isDarkMode = false;

  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final brightness = _isDarkMode ? Brightness.dark : Brightness.light;
    final backgroundColor = _isDarkMode ? Colors.grey[900] : Colors.white;
    final foregroundColor = _isDarkMode ? Colors.white : Colors.black;
    final iconColor = _isDarkMode ? Colors.white : Color.fromARGB(255, 5, 12, 49);
    final dividerColor = _isDarkMode ? Colors.grey[800] : Colors.grey[300];

    return Theme(
      data: ThemeData(
        brightness: brightness,
        backgroundColor: backgroundColor,
      ),
      child: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 5, 12, 49),
              image: DecorationImage(
                image: AssetImage('assets/images/drawer_header.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: const Text(
              "DONATIONS",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: dividerColor,
          ),
          ListTile(
            leading: Icon(Icons.business, color: iconColor),
            title: Text(
              "Organization",
              style: TextStyle(color: foregroundColor),
            ),
            onTap: () {
              Navigator.popUntil(context, ModalRoute.withName("/organizations"));
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: iconColor),
            title: Text(
              "Profile",
              style: TextStyle(color: foregroundColor),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/donorProfile");
            },
          ),
             ListTile(
          title: const Text('Logout'),
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
import 'package:flutter/material.dart';

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
        scaffoldBackgroundColor: backgroundColor,
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
          Divider(
            height: 1,
            thickness: 1,
            color: dividerColor,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              "Settings",
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.nightlight, color: iconColor),
            title: Text(
              "Dark Mode",
              style: TextStyle(color: foregroundColor),
            ),
            trailing: Switch(
              value: _isDarkMode,
              onChanged: _toggleDarkMode,
            ),
          ),
        ],
      ),
    ));
  }
}
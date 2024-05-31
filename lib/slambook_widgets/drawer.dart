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
    final userAuthProvider = Provider.of<UserAuthProvider>(context, listen: false); 
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
              // image: DecorationImage(
              //   image: AssetImage('lib/assets/elgivesLogo.png'),
                // fit: BoxFit.cover,
              ),
            child: Row(
            children: [
              Image.asset(
                'lib/assets/elgivesLogo.png',
                width: 50, // Adjust the width as needed
                height: 50, // Adjust the height as needed
              ),
              SizedBox(width: 10), // Adjust the spacing between the image and text
              Text(
                "DONATIONS",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
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
              // Navigator.pop(context);
              // Navigator.pushReplacementNamed(context, "/organizations");
              // Navigator.popUntil(context, ModalRoute.withName('/organizations'));
              // Navigator.pop(context);
              // if (ModalRoute.of(context)!.settings.name != "/organizations") {
              //   Navigator.pushReplacementNamed(context, "/organizations");
              // }
              Navigator.pop(context);
              var currentRoute = ModalRoute.of(context);
              if (!(currentRoute is MaterialPageRoute && currentRoute.settings.name == "/organizations")) {
                Navigator.pushReplacementNamed(context, "/organizations");
              }

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
              if (ModalRoute.of(context)!.settings.name != "/donorProfile") {
                Navigator.pushNamed(context, "/donorProfile");
              }
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

             ListTile(
          title: const Text('Logout'),
          onTap: () {
            context.read<UserAuthProvider>().signOut();
            Navigator.pop(context);
          },
        ),

        ],
      ),
    ));
  }
}
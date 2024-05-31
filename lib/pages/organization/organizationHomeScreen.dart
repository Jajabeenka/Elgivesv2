import 'package:elgivesv2/pages/organization/donationsList.dart';
import 'package:elgivesv2/pages/organization/orgProfile.dart';
import 'package:elgivesv2/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrganizationHomeScreen extends StatefulWidget {
  @override
  _OrganizationHomeScreenState createState() => _OrganizationHomeScreenState();
}

class _OrganizationHomeScreenState extends State<OrganizationHomeScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    DonationListPage(), // Updated to DonationListPage
    OrgProfile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ElGives Organization Page",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFC107),
          ),
        ),
        backgroundColor: const Color(0xFF01563F),
        iconTheme: const IconThemeData(color: Color(0xFF8D1436)),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color(0xFF01563F),
              ),
              child: Text(
                'Navigation Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text("All Donations",
                  style: TextStyle(color: Color.fromARGB(255, 5, 12, 49))),
              onTap: () {
                _onItemTapped(0); // Set index to show OrgProfile
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.monetization_on), // You can customize the icon
              title: Text('Organization Profile'), // Change the text to indicate All Donations
              onTap: () {
                _onItemTapped(1); // Set index to show AllDonationsPage
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                context.read<UserAuthProvider>().signOut();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

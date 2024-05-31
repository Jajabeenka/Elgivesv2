import 'package:elgivesv2/pages/userAdmin/admin/adminApprovalPage.dart';
import 'package:elgivesv2/pages/userAdmin/admin/adminDonors.dart';
import 'package:elgivesv2/pages/userAdmin/admin/adminOrganizations.dart';
import 'package:elgivesv2/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static  List<Widget> _widgetOptions = <Widget>[
    DonorListWidget(),
    OrganizationListWidget(),
    adminApproval(),
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
          "ElGives Admin App",
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
              leading: Icon(Icons.list),
              title: Text('Donors'),
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context); // Close the drawer
              },
            ),
             ListTile(
              leading: Icon(Icons.business),
              title: Text('Organizations'), // Add organizations option here
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.approval),
              title: Text('Admin Approval'),
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context); // Close the drawer
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

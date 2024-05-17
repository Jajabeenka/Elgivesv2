import 'package:flutter/material.dart';
import '../models/organization.dart';
import '../pages/donatePage.dart';
import '../models/donation.dart';
import '../slambook_widgets/drawer.dart';
import 'package:provider/provider.dart';
import '../provider/orgs_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrgsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> donationsListStream =
        context.watch<OrganizationProvider>().organization;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Organizations',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFC107),
          ),
        ),
        iconTheme: IconThemeData(color: Color(0xFF8D1436)),
        backgroundColor: Color(0xFF01563F),
      ),
      backgroundColor: Color(0xFF8D1436),
      drawer: DrawerWidget(),
      body: StreamBuilder(
        stream: donationsListStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error encountered! ${snapshot.error}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column( 
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.group, size: 80, color: Colors.blue.shade800),
                  SizedBox(height: 20),
                  Text(
                    'NO ORGANIZATIONS YET!',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                    child: Text('GO BACK TO SIGN IN'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              Organization org = Organization.fromJson(
                  snapshot.data?.docs[index].data() as Map<String, dynamic>);
              var id = snapshot.data?.docs[index].id;
              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.person, color: Color(0xFFFFC107)),
                    backgroundColor: Color(0xFF01563F),
                  ),
                  title: Text(
                    org.name,
                    style: TextStyle(
                      color: Color.fromARGB(255, 120, 90, 0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FormSample(),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
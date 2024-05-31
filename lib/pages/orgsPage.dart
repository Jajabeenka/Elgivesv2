import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/organization.dart';
import '../models/user.dart';
import '../pages/donatePage.dart';
import '../models/donation.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../slambook_widgets/drawer.dart';
import 'package:provider/provider.dart';
import '../provider/orgs_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrgsPage extends StatefulWidget {
  @override
  _OrgsPageState createState() => _OrgsPageState();
}

class _OrgsPageState extends State<OrgsPage> {
  @override
  void initState() {
    super.initState();
    // Fetch organizations data here
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchOrganizations();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Stream<QuerySnapshot> donationsListStream =
    //     context.watch<OrganizationProvider>().organization;

    final userProvider = Provider.of<UserProvider>(context);
    // final user = context.watch<UserProvider>();
    // final userId = user.selectedUser?.uid;
    String? getUserId() {
    User? user = context.read<UserAuthProvider>().user;
    if (user != null) {
      return user.uid;
    }
    return null;
  }
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
      backgroundColor: Color(0xFFF5F5F5),
      drawer: DrawerWidget(),
      body: StreamBuilder<List<AppUser>>(
        stream: userProvider.orgStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Something went wrong.",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8D1436),
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF01563F)),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.group, size: 80, color: Color(0xFF01563F)),
                  SizedBox(height: 20),
                  Text(
                    'No Organizations Yet!',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF01563F),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                    child: Text('GO BACK TO SIGN IN'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF01563F),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          String? uid = getUserId();
          final organizations = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: organizations.length,
              itemBuilder: (context, index) {
                final org = organizations[index];
                // Organization org = Organization.fromJson(
                //     snapshot.data?.docs[index].data() as Map<String, dynamic>);
                // var id = snapshot.data?.docs[index].id;
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FormSample(
                          orgName: org.name,
                          orgDescri: "This is an org",
                          orgStatus: org.status,
                          orgId: org.uid,
                          userId: uid!,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF01563F),
                          Color(0xFF8D1436),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30, 
                          child: Icon(
                            Icons.person,
                            color: Color(0xFFFFC107),
                            size: 36, 
                          ),
                          backgroundColor: Colors.white,
                        ),
                        SizedBox(height: 16),
                        Text(
                          org.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18, 
                            shadows: [ 
                              Shadow(
                                blurRadius: 2.0,
                                color: Colors.black.withOpacity(0.5),
                                offset: Offset(1.0, 1.0),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              org.status ? Icons.check_circle : Icons.cancel,
                              color: org.status ? Colors.green : Colors.red,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Status: ${org.status ? 'OPEN' : 'CLOSED'}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: org.status ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

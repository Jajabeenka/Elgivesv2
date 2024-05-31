import 'package:elgivesv2/models/user.dart';
import 'package:elgivesv2/pages/userAdmin/admin/adminDrawer.dart';
import 'package:elgivesv2/pages/userAdmin/admin/organizationDetailsPage.dart';
import 'package:elgivesv2/providers/user_provider.dart';
import 'package:elgivesv2/slambook_widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class adminApproval extends StatefulWidget {
  const adminApproval({super.key});

  @override
  State<adminApproval> createState() => _PendingOrganizationHomeState();
}

class _PendingOrganizationHomeState extends State<adminApproval> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().getAccountInfo(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8D1436),
      drawer: AdminDrawerWidget(),
      appBar: AppBar(
        title: const Text(
          "Pending Organizations",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFC107),
          ),
        ),
        backgroundColor: const Color(0xFF01563F),
        iconTheme: const IconThemeData(color: Color(0xFF8D1436)),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return StreamBuilder<List<AppUser>>(
            stream: userProvider.pendingOrgStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                    child: Text(
                  'No pending organizations found',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFC107),
                  ),
                ));
              } else {
                final pendingOrgs = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ListView.builder(
                    itemCount: pendingOrgs.length,
                    itemBuilder: (context, index) {
                      final pendingOrg = pendingOrgs[index];
                      return componentTiles(pendingOrg);
                    },
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget componentTiles(AppUser user) {
    return Card(
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey[200],
          child: Icon(
            Icons.person,
            size: 30,
            color: Colors.grey[600],
          ),
        ),
        title: Text(
          user.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        trailing: const Icon(
          Icons.navigate_next_rounded,
          color: Colors.grey,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  OrganizationDetailPage(orgId: user.uid, pending: true),
            ),
          );
        },
      ),
    );
  }
}

class OrganizationDetailPage extends StatefulWidget {
  final String orgId;
  final bool pending;

  const OrganizationDetailPage(
      {super.key, required this.orgId, required this.pending});

  @override
  State<OrganizationDetailPage> createState() => _OrganizationDetailPageState();
}

class _OrganizationDetailPageState extends State<OrganizationDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().getAccountInfo(widget.orgId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.read<UserProvider>().getAccountInfo(null);
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: body(),
    );
  }

  Widget body() {
    return Stack(
      children: [
        OrganizationDetails(uid: widget.orgId),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.pending) ...[
                  const SizedBox(height: 10),
                  approveButton(),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool approveButtonisPressed = false;
  Widget approveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: GestureDetector(
        child: ElevatedButton(
          onPressed: () async {
            setState(() {
              approveButtonisPressed = true;
            });

            AppUser? details = context.read<UserProvider>().selectedUser;
            AppUser duplicate = details!.duplicate(status: true);

            var message = await context
                .read<UserProvider>()
                .updateUser(widget.orgId, duplicate);
            print(message);

            if (mounted) {
              context.read<UserProvider>().getAccountInfo(null);
              Navigator.of(context).pop();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF01563F),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.login,
                color: Colors.white,
              ),
              SizedBox(width: 10.0),
              Text(
                "Approve",
                style: TextStyle(
                  color: const Color(0xFFFFC107),
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:elgivesv2/models/user.dart';
import 'package:elgivesv2/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminPending extends StatefulWidget {
  const AdminPending({super.key});

  @override
  State<AdminPending> createState() => _PendingOrganizationHomeState();
}

class _PendingOrganizationHomeState extends State<AdminPending> {
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
                return const Center(child: Text('Empty pending organizations'));
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
      margin: const EdgeInsets.symmetric(vertical: 10),
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
                  OrgDetailPage(orgId: user.uid, pending: true),
            ),
          );
        },
      ),
    );
  }
}

class OrgDetailPage extends StatefulWidget {
  final String orgId;
  final bool pending;

  const OrgDetailPage(
      {super.key, required this.orgId, required this.pending});

  @override
  State<OrgDetailPage> createState() => _OrgDetailPageState();
}

class _OrgDetailPageState extends State<OrgDetailPage> {
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
      backgroundColor: Color(0xFF8D1436),
      appBar: AppBar(
        title: Text(
          "Org Details",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFC107),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () {
            context.read<UserProvider>().getAccountInfo(null);
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Color(0xFF01563F),
        iconTheme: IconThemeData(color: Color(0xFF8D1436)),
      ),
      body: orgDetails(),

    );
  }

  Widget orgDetails() {
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
    return ElevatedButton(
      child: const Text("Approve"),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFC107),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: () async {
        setState(() {
          approveButtonisPressed = true;
        });

        AppUser? details = context.read<UserProvider>().selectedUser;
        AppUser detailsCopy = details!.duplicate(status: true);

        var message = await context
            .read<UserProvider>()
            .updateUser(widget.orgId, detailsCopy);
        print(message);

        if (mounted) {
          context.read<UserProvider>().getAccountInfo(null);
          Navigator.of(context).pop();
        }
      },
    );
  }
}

class OrganizationDetails extends StatefulWidget {
  final String uid;
  const OrganizationDetails({super.key, required this.uid});

  @override
  State<OrganizationDetails> createState() => _OrganizationDetailsState();
}

class _OrganizationDetailsState extends State<OrganizationDetails> {
  AppUser? organization;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().getAccountInfo(widget.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    organization = context.watch<UserProvider>().selectedUser;

    return organization == null
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                imageSection(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      aboutSection(),
                      const SizedBox(height: 15),
                      image()
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Widget aboutSection() {
    return Column(
      children: [
        Text(
          organization!.name,
          style: const TextStyle(
            color: Color(0xFF01563F),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "Email: " + organization!.email,
          style: const TextStyle(
            color: Color(0xFF01563F),
            fontSize: 18,
          ),
        ),
        Text(
          "Username: " + organization!.username,
          style: const TextStyle(
            color: Color(0xFF01563F),
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget imageSection() {
    return Stack(
      children: [
        const SizedBox(
          height: 225,
          width: double.infinity,
        ),
        SizedBox(
          height: 200,
          width: double.infinity,
          child: Container(
            color: Color(0xFFFFC107),
          ),
        ),
        Positioned(
          bottom: 0,
          left: (MediaQuery.of(context).size.width / 2) - 75,
          child: Container(
            width: 150,
            height: 150,
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const CircleAvatar(
              radius: 70,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                size: 70,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget image() {
  return Center(
    child: organization!.proof.isNotEmpty 
      ? ListView.builder(
          shrinkWrap: true,
          itemCount: organization!.proof.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                organization!.proof[index],
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  return const Icon(
                    Icons.error,
                    size: 100,
                    color: Colors.grey,
                  );
                },
              ),
            );
          },
        )
      : const Text('No images available'),
  );
}
}

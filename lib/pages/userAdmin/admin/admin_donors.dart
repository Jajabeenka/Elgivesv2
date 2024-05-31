import 'package:elgivesv2/models/user.dart';
import 'package:elgivesv2/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonorListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access the UserProvider instance
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF8D1436),
      body: StreamBuilder<List<AppUser>>(
        stream: userProvider.donorStream,
        builder: (context, snapshot) {
          // Handle possible states of the stream
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No donors found.'));
          } else {
            // Display the list of donors
            final donors = snapshot.data!;
            return ListView.builder(
              itemCount: donors.length,
              itemBuilder: (context, index) {
                final donor = donors[index];
                return ListTile(
                  title: Text(donor.name),
                  subtitle: Text(donor
                      .email), // assuming AppUser has name and email fields
                );
              },
            );
          }
        },
      ),
    );
  }
}

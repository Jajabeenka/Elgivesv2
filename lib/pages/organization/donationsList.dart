import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elgivesv2/models/donation.dart';
import 'package:elgivesv2/provider/donation_provider.dart';
import 'package:elgivesv2/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonationListPage extends StatelessWidget {
  static const primaryColor = Color(0xFF8D1436);
  static const secondaryColor = Color(0xFFFFC107);
  static const accentColor = Color(0xFF01563F);

  @override
  Widget build(BuildContext context) {
    final donationProvider = Provider.of<DonationProvider>(context);
    final userAuthProvider = Provider.of<UserAuthProvider>(context);

    void _showEditStatusDialog(BuildContext context, Donation donation) {
      String newStatus = donation.status;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Edit Donation Status', style: TextStyle(color: primaryColor)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: const Text('Pending'),
                  leading: Radio<String>(
                    value: 'Pending',
                    groupValue: newStatus,
                    onChanged: (String? value) {
                      if (value != null) {
                        newStatus = value;
                        Navigator.of(context).pop();
                        _showEditStatusDialog(context, donation.copyWith(status: newStatus));
                      }
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Confirmed'),
                  leading: Radio<String>(
                    value: 'Confirmed',
                    groupValue: newStatus,
                    onChanged: (String? value) {
                      if (value != null) {
                        newStatus = value;
                        Navigator.of(context).pop();
                        _showEditStatusDialog(context, donation.copyWith(status: newStatus));
                      }
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Scheduled for Pick-up'),
                  leading: Radio<String>(
                    value: 'Scheduled for Pick-up',
                    groupValue: newStatus,
                    onChanged: (String? value) {
                      if (value != null) {
                        newStatus = value;
                        Navigator.of(context).pop();
                        _showEditStatusDialog(context, donation.copyWith(status: newStatus));
                      }
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Complete'),
                  leading: Radio<String>(
                    value: 'Complete',
                    groupValue: newStatus,
                    onChanged: (String? value) {
                      if (value != null) {
                        newStatus = value;
                        Navigator.of(context).pop();
                        _showEditStatusDialog(context, donation.copyWith(status: newStatus));
                      }
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Canceled'),
                  leading: Radio<String>(
                    value: 'Canceled',
                    groupValue: newStatus,
                    onChanged: (String? value) {
                      if (value != null) {
                        newStatus = value;
                        Navigator.of(context).pop();
                        _showEditStatusDialog(context, donation.copyWith(status: newStatus));
                      }
                    },
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel', style: TextStyle(color: primaryColor)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                ),
                onPressed: () {
                  // Update the status in the database
                  donationProvider.editStatus(donation.donationId, newStatus);
                  Navigator.pop(context);
                },
                child: Text('Save', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text('Donations List',style: TextStyle(color: Colors.white)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: donationProvider.donation,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: secondaryColor));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: secondaryColor)));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No donations available', style: TextStyle(color: secondaryColor)));
          }

          var userId = userAuthProvider.user?.uid;

          var donations = snapshot.data!.docs
              .map((doc) {
                var data = doc.data() as Map<String, dynamic>;
                return Donation.fromJson(data);
              })
              .where((donation) => donation.orgId == userId)
              .toList();

          if (donations.isEmpty) {
            return Center(child: Text('No donations available for your organization', style: TextStyle(color: secondaryColor)));
          }

          return ListView.builder(
            itemCount: donations.length,
            itemBuilder: (context, index) {
              var donation = donations[index];
              return Card(
                color: secondaryColor,
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Address: ${donation.addresses}', style: TextStyle(color: accentColor)),
                      Text('Categories: ${donation.categories.join(', ')}', style: TextStyle(color: accentColor)),
                      Text('Pickup or Drop-off: ${donation.pickupOrDropOff}', style: TextStyle(color: accentColor)),
                      Text('Weight: ${donation.weight}', style: TextStyle(color: accentColor)),
                      Text('Contact Number: ${donation.contactNumber}', style: TextStyle(color: accentColor)),
                      Text('Status: ${donation.status}', style: TextStyle(color: accentColor)),
                    ],
                  ),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: accentColor),
                    onPressed: () {
                      // Handle editing status
                      _showEditStatusDialog(context, donation);
                    },
                    child: Text('Edit', style: TextStyle(color: Colors.white)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:elgivesv2/provider/donationDrive_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/drive.dart';

class DriveWidget extends StatelessWidget {
  final Drive drive;

  const DriveWidget({Key? key, required this.drive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(),
            SizedBox(height: 16),
            description(),
            SizedBox(height: 16),
            donationList(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            drive.driveName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
          decoration: BoxDecoration(
            color: Colors.blue.shade700,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Donation Drive',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget description() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade200,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          detailRow(
            label: 'Description:',
            value: drive.description ?? 'No description available.',
            icon: Icons.add_business,
          ),
          // Text(
          //   'DESCRIPTION',
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //     fontSize: 18,
          //     color: Colors.black87,
          //   ),
          // ),
          // SizedBox(height: 12),
          // Text(
          //   drive.description ?? 'No description available.',
          //   style: TextStyle(
          //     fontSize: 16,
          //     color: Colors.black87,
          //   ),
          // ),
          SizedBox(height: 12),
          detailRow(
            label: 'Organization:',
            value: drive.orgId ?? 'N/A',
            icon: Icons.business,
          ),
        ],
      ),
    );
  }

  Widget detailRow({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.grey.shade600,
          size: 20,
        ),
        SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget donationList() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade200,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DONATIONS',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          if (drive.donationList != null && drive.donationList!.isNotEmpty)
            Column(
              children: drive.donationList!.take(3).map((donationId) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.local_shipping, color: Colors.green.shade700),
                  title: Text(
                    'Donation #$donationId',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  onTap: () {
                    // Navigate to donation details
                  },
                );
              }).toList(),
            )
          else
            Text(
              'No donations yet.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
          if (drive.donationList != null && drive.donationList!.length > 3)
            TextButton(
              onPressed: () {
                // View all donations
              },
              child: Text(
                'View all ${drive.donationList!.length} donations',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blue.shade700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
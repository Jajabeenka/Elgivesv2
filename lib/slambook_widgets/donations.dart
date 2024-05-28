import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/donation.dart';

class DonationWidget extends StatelessWidget {
  final Donation donation;

  const DonationWidget({Key? key, required this.donation}) : super(key: key);

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
            details(),
            SizedBox(height: 16),
            itemCategory(),
            SizedBox(height: 16),
            imageAndWeight(),
            SizedBox(height: 16),
            cancelDonationButton(context),
          ],
        ),
      ),
    );
  }

  Widget header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "ORG NAME",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
          decoration: BoxDecoration(
            color: _getStatusColor(donation.status),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            donation.status ?? 'N/A',
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

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Pending':
        return Colors.orange.shade700;
      case 'Completed':
        return Colors.green.shade700;
      case 'Cancelled':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  Widget details() {
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
            'DETAILS',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          detailRow(
            label: 'Type:',
            value: donation.pickupOrDropOff,
            icon: Icons.swap_vert,
          ),
          detailRow(
            label: 'Date:',
            value: DateFormat('yyyy-MM-dd').format(donation.dateTime.toLocal()),
            icon: Icons.calendar_today,
          ),
          detailRow(
            label: 'Time:',
            value: DateFormat.Hm().format(donation.dateTime),
            icon: Icons.access_time,
          ),
          detailRow(
            label: 'Address:',
            value: donation.addresses ?? 'N/A',
            icon: Icons.location_on,
          ),
          detailRow(
            label: 'Number:',
            value: donation.contactNumber ?? 'N/A',
            icon: Icons.phone,
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
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
      ),
    );
  }

  Widget itemCategory() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade200,
      ),
      width: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ITEM CATEGORIES',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: donation.categories
                .map((category) => categoryChip(category, true))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget categoryChip(String category, bool selected) {
    return Chip(
      label: Text(
        category,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      backgroundColor: selected ? Colors.red.shade700 : Colors.grey.shade300,
      elevation: 2,
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
    );
  }

  Widget imageAndWeight() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Image.network(
              donation.photo!,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object objection, StackTrace? stackRace) {
                return const Icon(
                  Icons.error, //dito ilagay image
                  size: 100,
                  color: Colors.grey,
                );
              }
          ),),
        ),
        SizedBox(height: 12),
        Text(
          'Total Weight: ${donation.weight}', 
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget cancelDonationButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Handle cancellation
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        ),
        child: Text(
          'CANCEL DONATION',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
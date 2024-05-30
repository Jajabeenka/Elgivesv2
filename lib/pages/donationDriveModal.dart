import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/drive.dart';
import '../provider/donationDrive_provider.dart';

class DonationDriveModal extends StatelessWidget {
  final String type;
  final Drive? item;
  final TextEditingController _formFieldController = TextEditingController();

  DonationDriveModal({super.key, required this.type, required this.item});

  // Method to show the title of the modal depending on the functionality
  Text _buildTitle() {
    switch (type) {
      case 'Add':
        return const Text("Add Drive");
      case 'Edit':
        return const Text("Edit Drive");
      case 'Delete':
        return const Text("Delete Drive");
      default:
        return const Text("");
    }
  }

  // Method to build the content or body depending on the functionality
  Widget _buildContent(BuildContext context) {
    switch (type) {
      case 'Delete':
        {
          return Text(
            "Are you sure you want to delete '${item!.driveName}'?",
          );
        }
      // Edit and add will have input field in them
      default:
        return TextField(
          controller: _formFieldController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        );
    }
  }

  TextButton _dialogAction(BuildContext context) {
    return TextButton(
      onPressed: () {
        switch (type) {
          case 'Add':
            {
              // Instantiate a todo objeect to be inserted, default userID will be 1, the id will be the next id in the list
              Drive temp = Drive(
                  driveId: 1,
                  driveName: _formFieldController.text,
                  );

              context.read<DonationDriveProvider>().addDrive(temp);

              // Remove dialog after adding
              Navigator.of(context).pop();
              break;
            }
          case 'Edit':
            {
              context
                  .read<DonationDriveProvider>()
                  .editDrive(item!.id!, _formFieldController.text);

              // Remove dialog after editing
              Navigator.of(context).pop();
              break;
            }
          case 'Delete':
            {
              context.read<DonationDriveProvider>().deleteDrive(item!.id!);

              // Remove dialog after editing
              Navigator.of(context).pop();
              break;
            }
        }
      },
      style: TextButton.styleFrom(
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      child: Text(type),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildTitle(),
      content: _buildContent(context),

      // Contains two buttons - add/edit/delete, and cancel
      actions: <Widget>[
        _dialogAction(context),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}
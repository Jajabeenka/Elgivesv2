import 'package:flutter/material.dart';

class DriveName extends StatefulWidget {
  final Function callback;
  const DriveName(this.callback, {super.key});

  @override
  State<DriveName> createState() => _DriveNameState();
}

class _DriveNameState extends State<DriveName> {
  final TextEditingController _driveNameController = TextEditingController();

  @override
  void dispose() {
    _driveNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              'Enter Weight:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF01563F),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20), // Padding added here
            child: TextFormField(
              controller: _driveNameController,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              validator: (val) {
                if (val == null || val.isEmpty) return "Enter Name";
                if (int.tryParse(val) == null) return "Enter Name";
                return null;
              },
              onChanged: (value) {
                widget.callback(value);
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(80, 141, 20, 54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0xFF8D1436),
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0xFF8D1436),
                    width: 2,
                  ),
                ),
                hintText: "Enter Name",
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
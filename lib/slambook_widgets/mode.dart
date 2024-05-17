import 'package:flutter/material.dart';

class Mode extends StatefulWidget {
  final Function(String) onChanged;
  final String initialValue;

  Mode({
    Key? key,
    required this.onChanged,
    required this.initialValue,
  }) : super(key: key);

  @override
  _ModeState createState() => _ModeState();

  static final List<String> _dropdownOptions = [
    "Pickup",
    "Drop-off",
  ];
}

class _ModeState extends State<Mode> {
  late String _dropdownValue;

  @override
  void initState() {
    super.initState();
    _dropdownValue = widget.initialValue;
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
              'Select Mode:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF01563F),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10), 
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
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
              ),
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              value: _dropdownValue,
              items: Mode._dropdownOptions.map((option) {
                return DropdownMenuItem<String>(
                  child: Text(
                    option,
                    style: TextStyle(color: Colors.black),
                  ),
                  value: option,
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _dropdownValue = val!;
                });
                widget.onChanged(val!);
              },
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
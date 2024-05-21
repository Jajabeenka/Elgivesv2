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
}

class _ModeState extends State<Mode> {
  String _mode = "Pickup";

  @override
  void initState() {
    super.initState();
    _mode = widget.initialValue;
  }

  void _toggleMode() {
    setState(() {
      _mode = _mode == "Pickup" ? "Drop-off" : "Pickup";
    });
    widget.onChanged(_mode);
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
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          //   child: Text(
          //     'Select Mode:',
          //     style: TextStyle(
          //       fontSize: 18,
          //       fontWeight: FontWeight.bold,
          //       color: Color(0xFF01563F),
          //     ),
          //   ),
          // ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: _toggleMode,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Color(0xFF8D1436),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  _mode,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
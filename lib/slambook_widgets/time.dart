import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Time extends StatefulWidget {
  final Function(TimeOfDay) callback;
  final DateTime dateTime;
  const Time(this.callback, {Key? key, required this.dateTime})
      : super(key: key);

  @override
  State<Time> createState() => _TimeState();
}

class _TimeState extends State<Time> {
  TimeOfDay? selectedTime;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
      widget.callback(TimeOfDay.fromDateTime(DateTime(
        widget.dateTime.year,
        widget.dateTime.month,
        widget.dateTime.day,
        picked.hour,
        picked.minute,
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
      child: ElevatedButton(
        onPressed: () => _selectTime(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF01563F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.access_time, color: Color(0xFFFFC107),), // Add an icon here
              SizedBox(width: 8), // Add some spacing between icon and text
              Text(
                selectedTime != null
                    ? 'Selected Time: ${selectedTime!.format(context)}'
                    : 'Select Time ${DateFormat.Hm().format(DateTime.now())}'
,
                style: TextStyle(
                  color: Color(0xFFFFC107),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class Date extends StatefulWidget {
  final Function(DateTime) callback;
  final DateTime dateTime;
  const Date(this.callback, {Key? key, required this.dateTime})
      : super(key: key);

  @override
  State<Date> createState() => _DateState();
}

class _DateState extends State<Date> {
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2040),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      widget.callback(DateTime(
        picked.year,
        picked.month,
        picked.day,
        widget.dateTime.hour,
        widget.dateTime.minute,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
            child: ElevatedButton(
              onPressed: () => _selectDate(context),
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
                    Icon(Icons.calendar_today, color: Color(0xFFFFC107),), 
                    SizedBox(width: 8), 
                    Text(
                      selectedDate != null
                          ? 'Selected Date: ${selectedDate!.toString().split(' ')[0]}'
                          : 'Select Date',
                      style: TextStyle(
                        color: Color(0xFFFFC107),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
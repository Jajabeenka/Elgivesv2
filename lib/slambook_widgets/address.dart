import 'package:flutter/material.dart';

class Address extends StatefulWidget {
  final Function(String) callback;
  final FormFieldValidator<String>? validator; 

  const Address(this.callback, {Key? key, this.validator}) : super(key: key);
  
  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  String address = '';

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
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          //   child: Text(
          //     'Enter Address:',
          //     style: TextStyle(
          //       fontSize: 18,
          //       fontWeight: FontWeight.bold,
          //       color: Color(0xFF01563F),
          //     ),
          //   ),
          // ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: TextFormField(
              initialValue: address,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              onChanged: (value) {
                address = value;
                widget.callback(address);
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
                labelText: "Address",
                hintText: "Enter your Address",
                hintStyle: TextStyle(color: Colors.grey),
              ),
              validator: widget.validator,
            ),
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}
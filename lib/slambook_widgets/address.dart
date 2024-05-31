import 'package:flutter/material.dart';

class Address extends StatefulWidget {
  final List<String> userAddresses;
  final Function(String?)? onChanged;
  final String? initialValue;

  const Address({
    Key? key,
    required this.userAddresses,
    this.onChanged,
    this.initialValue,
  }) : super(key: key);

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  String? selectedAddress;

  @override
  void initState() {
    super.initState();
    selectedAddress = widget.initialValue;
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: DropdownButtonFormField<String>(
          value: selectedAddress,
          onChanged: (String? newValue) {
            setState(() {
              selectedAddress = newValue;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(newValue);
            }
          },
          items: widget.userAddresses.map<DropdownMenuItem<String>>((String address) {
            return DropdownMenuItem<String>(
              value: address,
              child: Text(address),
            );
          }).toList(),
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
            hintText: "Select your Address",
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class Address extends StatefulWidget {
  final Function(List<String>) callback;
  const Address(this.callback, {Key? key}) : super(key: key);

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  List<String> addresses = [];

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              'Add Addresses:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF01563F),
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: addresses.length + 1,
            itemBuilder: (context, index) {
              if (index == addresses.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        addresses.add('');
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: Color(0xFFFFC107)),
                        SizedBox(width: 10),
                        Text(
                          'Add Address',
                          style: TextStyle(color: Color(0xFFFFC107)),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF01563F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: TextFormField(
                  initialValue: addresses[index],
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  onChanged: (value) {
                    addresses[index] = value;
                    widget.callback(addresses);
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
                    labelText: "Address ${index + 1}",
                    hintText: "Enter your Address",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
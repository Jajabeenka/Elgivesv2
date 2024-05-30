import 'package:flutter/material.dart';

class AddDrivePage extends StatelessWidget {
  const AddDrivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add Donation Drive',
      home: Scaffold(
        appBar: AppBar(title: Text('Add Donation Drive'),),
        body: Column (
          children: [
            Container(
              width: 280,
              margin: EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 10),
              child: TextField(
                style: TextStyle(
                  fontSize: 20,
                  height: 1.3,
                  color: Colors.black
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: "Name",
                  labelStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.black
                  )
                )
              )
            ),
            Container(
              width: 280,
              margin: EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 10),
              child: TextField(
                style: TextStyle(
                  fontSize: 20,
                  height: 1.3,
                  color: Colors.black
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: "Description",
                  labelStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.black
                  )
                )
              )
            ),
          ],
        )
      ),
    );
  }
}
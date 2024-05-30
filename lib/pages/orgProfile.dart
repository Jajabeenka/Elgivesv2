import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OrgProfile extends StatelessWidget {

  const OrgProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organization Profile', 
              style: TextStyle(color: Colors.white),
              ),
        backgroundColor: const Color.fromARGB(255, 8, 64, 60),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF9F1010),
        ),
        child: Column(
          children: [ 
            SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(6.0),
                padding: const EdgeInsets.all(7.0),
                width: MediaQuery.of(context).size.width,
                height: 175.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: const Color.fromARGB(255, 255, 255, 255),
                  border: Border.all(
                    width: 5,
                    color: const Color(0xFFFFC107),
                  )
                ),
                child: const Column(
                children: [
                  //org logo and name
                  Row(
                    children: [
                      Text('<logo>', style: TextStyle(color: Color(0xFF9F1010))),
                      SizedBox(width: 20.0),
                      Text('Elgives Charity', style: TextStyle(color: Color(0xFF9F1010), fontWeight: FontWeight.bold)),
                      Spacer(),
                        //edit button
                      Align(
                        alignment: Alignment.topRight,
                        child: SizedBox(
                          width: 30.0,
                          height: 30.0,
                          child: FittedBox(
                            child: FloatingActionButton(
                              onPressed: null,
                              child: Icon(Icons.edit),
                            ),
                          ),
                        )
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    children: [
                      Text('About', style: TextStyle(color: Color(0xFF9F1010), fontSize: 25, fontWeight: FontWeight.bold)),
                    ],
                  ),                  
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    ),
                  ),
                ],
              ),
              )
            ),
            //list of charities
            Expanded (
              child: ListView(
                children: [
                  Container (
                    margin: const EdgeInsets.all(6.0),
                    padding: const EdgeInsets.all(7.0),
                    height: 60.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: const Color.fromARGB(255, 255, 255, 255),
                      border: Border.all(
                        width: 2,
                        color: Colors.black,
                      )
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Charity Name", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text("OPEN", style: TextStyle(color: Color.fromARGB(255, 8, 64, 60), fontSize: 20, fontWeight: FontWeight.bold)),
                      ],),
                  ),
                ],
              )
            ),
            Container(
              margin: const EdgeInsets.all(6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 30.0,
                    height: 30.0,
                    child: FittedBox(
                      child: FloatingActionButton(
                        onPressed: null,
                        child: Icon(Icons.arrow_back),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30.0,
                    height: 30.0,
                    child: FittedBox(
                      child: FloatingActionButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/donationDrive');
                        },
                        child: Icon(Icons.arrow_forward),
                      ),
                    ),
                  ),
                ]
              ),
            )
          ],
        ),
      ),

    );
  }
}


// child: ElevatedButton(
        //   child: const Text('Go to Second route'),
        //     onPressed: () {
        //     // Navigate to second route
        //     },
        //   ),

        
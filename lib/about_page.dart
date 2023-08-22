// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'home_screen.dart';

class About_page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                // CustomAppBar(),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                              fontSize: 30.0, color: Color(0XFF000000)),
                          children: [
                            TextSpan(
                              text: 'Habit',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 254, 17, 0)
                              ),
                            ),
                            TextSpan(text: ' Tracker'),
                          ],
                        ),
                      ),
                      // const DrawerButtonIcon()
                      GestureDetector(
                        onTap: () {
                          // show more actions
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                alignment: Alignment.topRight,

                                // title: Text('Actions'),
                                content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        title: Text('About Us'),
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  About_page(),
                                            ),
                                          );
                                        },
                                      ),
                                      ListTile(
                                        title: Text('Homepage'),
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  HomePage(),
                                            ),
                                          );
                                        },
                                      ),
                                    ]),
                              );
                            },
                          );
                        },
                        // child: Image.asset('assets/icons/Vectormenu.png'),
                        child: Icon(Icons.more_vert_rounded),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                Image.asset(
                  'assets/images/logo.png',
                  width: 350,
                  height: 240,
                ),
                const SizedBox(height: 7.0),
                Container(
                  padding: EdgeInsets.only(
                    bottom: 4, // Space between underline and text
                  ),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    width: 2.0, // Underline thickness
                  ))),
                  child: Text(
                    "About us",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 8.0),
                  child: const Text(
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum has been the industry.Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. ',
                    style: TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(height: 5),
                // details about company
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, top: 10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0),
                      ),
                      // color: Color.fromARGB(255, 101, 204, 90),
                      color: const Color.fromARGB(255, 255, 17, 0).withOpacity(0.2),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Thulo Technology',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            fontFamily: 'ukhanFont',
                            color: const Color.fromARGB(255, 1, 8, 17),
                          ),
                          
                        ),
                        Divider(
                                    thickness: 2, // Set the thickness of the line
                                    //color: Colors.red, // Set the color of the line
                                  ),
                        const Text(
                          'Thulo Technology is a software development company that specializes in mobile application development. It is a team of highly motivated and skilled individuals who are passionate about creating innovative solutions to real-world problems.',
                          style: TextStyle(fontSize: 16.0),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                      ),
                      // color: Color.fromARGB(255, 109, 230, 96),
                      color: Color.fromARGB(255, 255, 17, 0),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Contact Us For App Development',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.white,
                            
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // email
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                // ignore: deprecated_member_use
                                // launch('mailto:info@thulotechnology.com');
                              },
                              child: Icon(
                                Icons.email,
                                
                                size: 40,
                                color: Colors.white
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            InkWell(
                              onTap: () {
                                // ignore: deprecated_member_use
                                // launch('tel:+977-984-1234567');
                              },
                              child: Icon(
                                Icons.phone,
                                size: 40,
                                color: Colors.white
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                    child: Text(
                      "Return Homepage",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.black,
                      elevation: 3.0,
                      primary: Color(0xFFB3FFAE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height:  MediaQuery.of(context).size.height*0.05,
                )
              ],
            ),
          ),
        ));
  }
}

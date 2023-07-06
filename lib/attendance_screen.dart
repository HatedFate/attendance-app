import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    Color primary = const Color(0xffeef444c);

    return Scaffold(
        body: Column(
      children: [
        Container(
            height: screenHeight / 3,
            width: screenWidth,
            decoration: BoxDecoration(
                color: primary,
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(40),
                    bottomLeft: Radius.circular(40))),
            child: Center(
                child: Icon(Icons.person,
                    color: Colors.white, size: screenWidth / 5))),
        Container(
            margin: EdgeInsets.only(
                top: screenHeight / 15, bottom: screenHeight / 20),
            child: Text("Sign In",
                style: TextStyle(
                  fontSize: screenWidth / 40,
                  fontFamily: "NexaBold",
                ))),
        Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.symmetric(horizontal: screenWidth / 12),
            child: Column(
              children: [
                Container(
                  width: screenWidth,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Row(
                    children: [
                      SizedBox(
                        width: screenWidth / 20,
                        child: const Icon(Icons.person),
                      ),
                      Expanded(
                          child: TextFormField(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: screenHeight / 35),
                            hintText: "First Name"),
                      )),
                      const SizedBox(width: 30),
                      Expanded(
                          child: TextFormField(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: screenHeight / 35),
                            hintText: "Last Name"),
                      )),
                    ],
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(
                        top: screenHeight / 15, bottom: screenHeight / 20),
                    child: Text("Or Scan",
                        style: TextStyle(
                          fontSize: screenWidth / 40,
                          fontFamily: "NexaBold",
                        ))),
                GestureDetector(
                  onTap: () async {
                    print("213125");
                  },
                  child: Container(
                      height: screenWidth / 5,
                      width: screenWidth / 5,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(2, 2),
                                blurRadius: 10)
                          ]),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(FontAwesomeIcons.expand,
                              size: 100, color: primary),
                          Icon(FontAwesomeIcons.camera,
                              size: 35, color: primary)
                        ],
                      )),
                )
              ],
            )),
      ],
    ));
  }
}

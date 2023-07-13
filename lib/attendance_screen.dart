import "package:flutter/material.dart";
import "attendance.dart";

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key, required this.checkIn}) : super(key: key);

  final bool checkIn;

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final fieldText = TextEditingController();

  void clearText() {
    fieldText.clear();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    Color primary = const Color(0xffeef444c);

    return Scaffold(
        appBar: AppBar(title: Text(widget.checkIn ? "Check In" : "Check Out")),
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
                child: Text(
                    widget.checkIn ? "Scan to Check In" : "Scan to Check Out",
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
                                          vertical: screenHeight / 35)),
                                  onFieldSubmitted: (value) {
                                    query(value, widget.checkIn);
                                    clearText();
                                  },
                                  controller: fieldText,
                                  textInputAction: TextInputAction.done))
                        ],
                      ),
                    ),
                  ],
                )),
          ],
        ));
  }
}

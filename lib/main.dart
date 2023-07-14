import "package:attendance/attendance_screen.dart";
import "package:attendance/button_widget.dart";
import "package:flutter/material.dart";
import "attendance.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Attendance App",
        theme: ThemeData(primarySwatch: Colors.red),
        home: const MyAppPage());
  }
}

class MyAppPage extends StatefulWidget {
  const MyAppPage({Key? key}) : super(key: key);

  @override
  State<MyAppPage> createState() => _MyAppPageState();
}

class _MyAppPageState extends State<MyAppPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text("Attendance App")),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonWidget(
                text: "Check In",
                onClicked: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const AttendanceScreen(checkIn: true)))),
            const SizedBox(height: 72),
            ButtonWidget(
                text: "Check Out",
                onClicked: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const AttendanceScreen(checkIn: false))))
          ],
        )),
        floatingActionButton: const FloatingActionButton(
            onPressed: downloadRecord,
            tooltip: "Download Record",
            child: Icon(Icons.download)),
      );
}

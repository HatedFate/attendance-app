import "dart:io";
import "package:flutter/cupertino.dart";
import "package:path/path.dart";
import "package:excel/excel.dart";
import "package:intl/intl.dart";
import "package:quickalert/quickalert.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";

Directory current = Directory.current;

String file = "${current.path}\\assets\\test.xlsx";
String databasePath = "${current.path}\\assets\\test.db";

String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
String time = DateFormat("HH:mm").format(DateTime.now());

Future query(BuildContext context, String code, bool checkIn) async {
  databaseFactory = databaseFactoryFfi;
  Database db = await openDatabase(databasePath, version: 1,
      onCreate: (Database db, int version) async {
    await db.execute(
        "CREATE TABLE IF NOT EXISTS TEST (id INTEGER PRIMARY KEY, QR_CODE TEXT, "
        "FIRST_NAME TEXT NOT NULL, LAST_NAME TEXT NOT NULL, "
        "DATE TEXT, CHECK_IN TEXT, CHECK_OUT TEXT)");
  });

  dynamic bytes = File(file).readAsBytesSync();
  Excel excel = Excel.decodeBytes(bytes);
  Sheet sheet1 = excel["Sheet1"];

  int cnt = 0;
  for (int row = 1; row < sheet1.maxRows; row++) {
    if (sheet1.row(row).elementAt(0) != null) {
      List<Data?> authCode = sheet1.row(row);
      if (context.mounted && authCode.elementAt(0)!.value.toString() == code) {
        add(context, authCode, excel, checkIn, db);
        cnt = await deleteDuplicates(db, code);
        if (context.mounted && cnt > 0) {
          warning(context, "User had already checked in!");
        }
        return;
      }
    }
  }

  if (context.mounted) warning(context, "User cannot be found!");
}

void add(BuildContext context, List<Data?> item, Excel excel, bool checkIn,
    Database db) async {
  String code = item.elementAt(0)!.value.toString();
  String fName = item.elementAt(1)!.value.toString();
  String lName = item.elementAt(2)!.value.toString();

  if (checkIn) {
    await db.transaction((txn) async {
      await txn.rawInsert(
          "INSERT INTO TEST(QR_CODE, FIRST_NAME, LAST_NAME, DATE, CHECK_IN, CHECK_OUT) "
          "VALUES(?, ?, ?, ?, ?, ?)",
          [code, fName, lName, date, time, null]);
    });
  } else {
    List<Map> checkOutToday = await db.rawQuery(
        "SELECT * FROM TEST WHERE QR_CODE = ? AND DATE = ?", [code, date]);

    if (checkOutToday.isNotEmpty) {
      bool checkOutDuplicates = checkOutToday.last.containsValue(null);

      if (context.mounted && !checkOutDuplicates) {
        warning(context, "User had already checked out!");

        return;
      }
    }

    int cnt = await db.rawUpdate(
        "UPDATE TEST SET CHECK_OUT = ? WHERE QR_CODE = ? AND DATE = ?",
        [time, code, date]);

    if (cnt == 0 && context.mounted) {
      warning(context, "User did not checked in yet!");
    }
  }
}

void downloadRecord() async {
  databaseFactory = databaseFactoryFfi;
  Database db = await openDatabase(databasePath, version: 1);

  Excel excel = Excel.createExcel();
  List<String?> header = <String?>[
    "ID",
    "Code",
    "First Name",
    "Last Name",
    "Date",
    "Check In",
    "Check Out"
  ];

  excel.appendRow("Sheet1", header);

  List<Map> list = await db.rawQuery("SELECT * FROM TEST");
  if (list.isEmpty) return;

  for (Map item in list) {
    List<String?> recordData =
        item.entries.map((e) => e.value.toString()).toList();
    excel.appendRow("Sheet1", recordData);
  }

  String outputFile = "${current.path}\\assets\\Record.xlsx";
  List<int>? fileBytes = excel.save(fileName: "Record");
  if (fileBytes != null) {
    File(join(outputFile))
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes);
  }
}

void warning(BuildContext context, String text) {
  if (context.mounted) {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        title: "Warning",
        text: text);
  }
}

Future<int> deleteDuplicates(Database db, String code) async {
  int cnt1 = await db.rawDelete("DELETE FROM TEST WHERE rowid NOT IN "
      "(SELECT MIN(rowid) FROM TEST GROUP BY QR_CODE, DATE)");

  return cnt1;
}

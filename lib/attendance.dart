import "package:excel/excel.dart";
import "package:intl/intl.dart";
import "dart:io";
import "package:sqflite_common_ffi/sqflite_ffi.dart";

Future search(String code, bool checkIn) async {
  String file =
      "path\\assets\\test.xlsx";
  String databasePath =
      "path\\assets\\test.db";

  databaseFactory = databaseFactoryFfi;
  Database db = await openDatabase(databasePath, version: 1,
      onCreate: (Database db, int version) async {
    await db.execute(
        "CREATE TABLE TEST (id INTEGER PRIMARY KEY, QR_CODE TEXT, "
        "FIRST_NAME TEXT NOT NULL, LAST_NAME TEXT NOT NULL, "
        "DATE TEXT, CHECK_IN TEXT, CHECK_OUT TEXT)");
  });

  var bytes = File(file).readAsBytesSync();
  Excel excel = Excel.decodeBytes(bytes);
  Sheet sheet1 = excel["Sheet1"];

  for (int row = 1; row < sheet1.maxRows; row++) {
    if (sheet1.row(row).elementAt(0) != null) {
      List<Data?> authCode = sheet1.row(row);
      if (authCode.elementAt(0)!.value.toString() == code) {
        add(authCode, excel, checkIn, db);
      }
    }
  }
}

void add(List<Data?> item, Excel excel, bool checkIn, Database db) async {
  String code = item.elementAt(0)!.value.toString();
  String fName = item.elementAt(1)!.value.toString();
  String lName = item.elementAt(2)!.value.toString();
  String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String time = DateFormat("HH:mm").format(DateTime.now());

  if (checkIn) {
    await db.transaction((txn) async {
      await txn.rawInsert(
          "INSERT INTO TEST(QR_CODE, FIRST_NAME, LAST_NAME, DATE, CHECK_IN, CHECK_OUT) "
              "VALUES(?, ?, ?, ?, ?, ?)", [code, fName, lName, date, time, null]);
    });
  } else {
    await db.rawUpdate(
      "UPDATE TEST SET CHECK_OUT = ? WHERE QR_CODE = ? AND DATE = ?",
      [time, code, date]
    );
  }
}

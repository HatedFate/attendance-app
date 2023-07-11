import "package:excel/excel.dart";
import "package:intl/intl.dart";
import "package:flutter/services.dart" show ByteData, rootBundle;

void search(String code, bool checkIn) async {
  var file = "../assets/test.xlsx";

  ByteData data = await rootBundle.load(file);
  dynamic bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  Excel excel = Excel.decodeBytes(bytes);
  Sheet sheet1 = excel["Sheet1"];

  for (int row = 1; row < sheet1.maxRows; row++) {
    if (sheet1.row(row).elementAt(0) != null) {
      List<Data?> authCode = sheet1.row(row);
      if (authCode.elementAt(0)!.value.toString() == code) {
        add(authCode, excel);
      }
    }
  }
}

void add(List<Data?> item, Excel excel) {
  var dt = DateTime.now();
  var sheet2 = excel["Sheet2"];

  String fName = item.elementAt(1).toString();
  String lName = item.elementAt(2).toString();
  String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String time = DateFormat("HH:mm").format(DateTime.now());
}

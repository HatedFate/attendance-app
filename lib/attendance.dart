import "package:excel/excel.dart";
import "package:intl/intl.dart";
import "package:flutter/services.dart" show ByteData, rootBundle;

void search(String code, bool checkIn) async {
  var file = "../assets/test.xlsx";

  ByteData data = await rootBundle.load(file);
  dynamic bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  Excel excel = Excel.decodeBytes(bytes);
  Sheet sheet1 = excel["Sheet1"];

  for (int row = 1; row < sheet1.maxRows; row++) {
    if (sheet1.row(row).elementAt(0) != null) {
      List<Data?> authCode = sheet1.row(row);
      if (authCode.elementAt(0)!.value.toString() == code) {
        add(authCode, excel, checkIn);
      }
    }
  }
}

void add(List<Data?> item, Excel excel, bool checkIn) async {
  var sheet2 = excel["Sheet2"];

  String code = item.elementAt(0)!.value.toString();
  String fName = item.elementAt(1)!.value.toString();
  String lName = item.elementAt(2)!.value.toString();
  String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String time = DateFormat("HH:mm").format(DateTime.now());

  if (checkIn) {
    List<String?> itemList = <String?>[code, fName, lName, date, time, null];
    sheet2.appendRow(itemList);
  } else {
    for (int row = sheet2.maxRows - 1; row > 0; row--) {
      List<Data?> data = sheet2.row(row);
      if (data.elementAt(3)!.value.toString() != date) return;
      if (data.elementAt(0)!.value.toString() == code) {
        Data cell = sheet2.cell(CellIndex.indexByString("D$row"));
        cell.value = time;
      }
    }
  }
}

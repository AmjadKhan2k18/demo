import 'package:demo/helpers/local_db.dart';
import 'package:flutter/material.dart';

class LocalDbState with ChangeNotifier {
  List<Map<String, dynamic>> cities;

  LocalDbState() {
    getData();
  }

  getData() async {
    cities = await dbHelper.queryAllRows(DatabaseHelper.tableName);
    notifyListeners();
  }
}

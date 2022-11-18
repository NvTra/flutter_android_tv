import 'dart:convert';
import 'package:flutter/services.dart';

class DataProvider {
  static Future<dynamic> load() async {
    final String response = await rootBundle.loadString('assets/data/data.json');
    return await json.decode(response);
// ...
  }
}
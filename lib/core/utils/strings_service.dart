import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:insta_downloader/data/app_strings_model.dart';

class StringsService {
  static AppStringsModel? _strings;

  static AppStringsModel get strings {
    if (_strings == null) {
      throw Exception('StringsService not initialized. Call init() first.');
    }
    return _strings!;
  }

  static Future<void> init() async {
    final jsonString =
        await rootBundle.loadString('assets/json/app_strings.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    _strings = AppStringsModel.fromJson(jsonMap);
  }
}

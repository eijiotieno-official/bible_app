import 'dart:convert';

import 'package:bible_app/src/models/bible_version_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BibleVersionCacheService {
  static Future<BibleVersion?> read() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    final stringResult = sharedPreferences.getString('version');

    if (stringResult == null) return null;

    final version = BibleVersion.fromJson(jsonDecode(stringResult));

    return version;
  }

  static Future<void> save(BibleVersion? version) async {
    if (version == null) return;

    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    final versionString = jsonEncode(version.toJson());

    await sharedPreferences.setString('version', versionString);
  }
}

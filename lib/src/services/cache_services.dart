import 'dart:convert';

import 'package:bible_app/src/models/bible_version_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

String _index = 'index';

String _version = 'version';

class CacheServices {
  static Future<int?> readVerseIndex() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    return sharedPreferences.getInt(_index);
  }

  static Future<void> saveVerseIndex(int index) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    await sharedPreferences.setInt(_index, index);
  }

  static Future<BibleVersion?> readVersion() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    final stringResult = sharedPreferences.getString(_version);

    if (stringResult == null) return null;

    final version = BibleVersion.fromJson(jsonDecode(stringResult));

    return version;
  }

  static Future<void> saveVersion(BibleVersion? version) async {
    if (version == null) return;

    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    final versionString = jsonEncode(version.toJson());

    await sharedPreferences.setString(_version, versionString);
  }
}

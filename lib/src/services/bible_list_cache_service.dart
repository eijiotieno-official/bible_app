import 'package:shared_preferences/shared_preferences.dart';

class BibleListCacheService {
  static Future<int?> read() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    return sharedPreferences.getInt('index');
  }

  static Future<void> save(int index) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    await Future.delayed(
      const Duration(milliseconds: 300),
      () async => await sharedPreferences.setInt('index', index),
    );
  }
}

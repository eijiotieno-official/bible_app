import 'package:shared_preferences/shared_preferences.dart';

class ScrollCacheService {
  static Future<double?> read() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    return sharedPreferences.getDouble('pixels');
  }

  static Future<void> save(double pixels) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    await sharedPreferences.setDouble('pixels', pixels);
  }
}

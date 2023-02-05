import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsServices {
  setStringData(String key, String? data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, data!);
  }

  Future<String?> getStringData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? resutl = prefs.getString(key);
    return resutl;
  }

  // get data from shared prefs
  Future<String?> getCurrentLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('langs') ?? "ar";
  }
}

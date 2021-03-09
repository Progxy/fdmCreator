import 'package:shared_preferences/shared_preferences.dart';

class LogFileManager {
  ///Store data as a Map with given String as Key and the value as Value.
  Future<void> storeData(String data, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(data, value);
    return;
  }

  ///Return true if the given data there's.
  Future<bool> getData(String data) async {
    final prefs = await SharedPreferences.getInstance();
    final result = prefs.getBool(data) ?? false;
    return result;
  }

  ///Remove the given data.
  Future<void> removeData(String data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(data);
    return;
  }

  ///Return true if is the first time using the app,
  ///and also store the number of times is been called since the first.
  Future<bool> firstVisit() async {
    final prefs = await SharedPreferences.getInstance();
    int counter = prefs.getInt('counter') ?? 0;
    if (counter == 0) {
      counter++;
      prefs.setInt('counter', counter);
      return true;
    }
    counter++;
    prefs.setInt('counter', counter);
    return false;
  }
}

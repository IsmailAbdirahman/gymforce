
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  saveLocation(String locationn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('locations', locationn);
    print("The shared pref is${prefs.toString()}");
  }

  Future<List<String>> getLocation(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> locationArray = prefs.getString(key).split(",");
    return locationArray;
  }

  clearTheData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }




  saveLocationAsAddress(String locationn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('address', locationn);
    print("The shared pref is${prefs.toString()}");
  }

  Future<String> getLocationAsAddress(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String locationArray = prefs.getString(key);
    return locationArray;
  }
}

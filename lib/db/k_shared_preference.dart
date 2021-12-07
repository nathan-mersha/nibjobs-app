import 'package:shared_preferences/shared_preferences.dart';

class HSharedPreference {
  static const KEY_FIRST_TIME = "FIRST_TIME";
  static const KEY_FIRST_INVOICE_NUMBER = "FIRST_INVOICE_NUMBER";
  static const KEY_USER_ID = "KEY_USER_ID";
  static const KEY_USER_NAME = "KEY_USER_NAME";
  static const KEY_USER_EMAIL = "KEY_USER_EMAIL";
  static const KEY_USER_PHONE = "KEY_USER_PHONE";
  static const KEY_USER_HAS_SHOP = "KEY_USER_HAS_SHOP";
  static const KEY_USER_IMAGE_URL = "KEY_USER_IMAGE_URL";
  static const LIST_OF_FAV = "LIST_OF_FAV";
  static const SELECT_PREFERENCE = "SELECT_PREFERENCE";
  static const LIST_OF_FAV_CATEGORY = "LIST_OF_FAV_CATEGORY";
  static const LIST_OF_CATEGORY_ORDER = "LIST_OF_CATEGORY_ORDER";
  static const LOCALE = "LOCALE";
  static const THEME = "THEME";
  static const SHOW_INFO = "SHOW_INFO";

  Future<bool> set(String? key, dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (value is int) {
      return prefs.setInt(key!, value);
    } else if (value is String) {
      return prefs.setString(key!, value);
    } else if (value is bool) {
      return prefs.setBool(key!, value);
    } else if (value is double) {
      return prefs.setDouble(key!, value);
    } else if (value is List) {
      return prefs.setStringList(key!, value as List<String>);
    } else {
      return prefs.setString(key!, value.toString());
    }
  }

  dynamic get(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (key == "LIST_OF_FAV" ||
        key == "LIST_RECENT_CITIES" ||
        key == "LIST_OF_FAV_CATEGORY" ||
        key == "LIST_OF_CATEGORY_ORDER") {
      return prefs.getStringList(key);
    }
    return prefs.get(key);
  }
}

class GetHSPInstance {
  static HSharedPreference hSharedPreference = HSharedPreference();
}

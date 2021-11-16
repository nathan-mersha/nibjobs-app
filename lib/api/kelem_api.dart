import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

/// Hisab Public Addresses
class Config {
  static String dnAdrs = "https://www.googleapis.com";
}

class Helper {
  /// Checks if either wifi or mobile data is on, but not necessarily if there is internet.
  static Future<bool> gotInternet() {
    //Connectivity connectivity = Connectivity();
    return Future.value(true);
    /*connectivity.checkConnectivity().then((ConnectivityResult result) {
      return result.toString() == "ConnectivityResult.wifi" ||
          result.toString() == "ConnectivityResult.mobile";
    });*/
  }

  /// Trims phone number of format "0967823595" and "251967823595" and "67823595" to "67823595"
  static String phoneTrimmer(String originalPhone) {
    if (originalPhone.startsWith("09") && originalPhone.length == 10) {
      return originalPhone.trim().substring(2, originalPhone.length);
    } else if (originalPhone.startsWith("251") && originalPhone.length == 12) {
      return originalPhone.trim().substring(4, originalPhone.length);
    } else if (originalPhone.startsWith("+251") && originalPhone.length == 13) {
      return originalPhone.trim().substring(5, originalPhone.length);
    } else if (originalPhone.startsWith("09") && originalPhone.length == 9) {
      return originalPhone.trim().substring(1, originalPhone.length);
    } else if (originalPhone.length == 8) {
      return originalPhone;
    } else {
      throw Exception("Unknown phone format : $originalPhone");
    }
  }
}

class SearchAPI {
  static String _bookURL = "http://178.62.83.84:8000/server/ts/search";
  static Future<List> getSearchData(
      {String? document, String? fields, String? query}) {
    return Helper.gotInternet().then((bool thereIsInternet) {
      // Got internet
      if (thereIsInternet) {
        var url = Uri.parse("$_bookURL/$document/$fields/$query");
        return http.get(
          url,
          headers: {"Content-Type": "application/json"},
        ).then((http.Response response) {
          Map<String, dynamic> responseBodyMap = jsonDecode(response.body);
          List responseBody = responseBodyMap["hits"];
          return responseBody;
        }, onError: (err) {
          return null;
        });
      }
      // No internet, Dial ussd
      else {
        return [];
      }
    });
  }
}

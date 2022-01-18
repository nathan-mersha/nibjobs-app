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
}

class SearchAPI {
  static String _searchURL = "https://nibjobs.com/server/ts/search/job/title";
  static Future<List> getSearchData(
      {String? document, String? fields, String? query}) {
    return Helper.gotInternet().then((bool thereIsInternet) {
      // Got internet
      if (thereIsInternet) {
        var url = Uri.parse("$_searchURL/$query");
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

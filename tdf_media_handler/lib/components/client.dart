import "package:http/http.dart" as http;
import 'dart:convert';

const baseUrl = "http://192.168.1.5:5000";

class BaseClientAPI {
  var client = http.Client();
  Future<dynamic> askInfo(String api) async {
    var url = Uri.parse(baseUrl + api);
    var response = await client.get(url);
    return jsonDecode(response.body);
  }
}

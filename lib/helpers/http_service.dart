import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpService {
  static String baseUrl = "http://api.openweathermap.org/";

  static Future<Map<String, dynamic>> getRequest(
      {String city, String apiKey}) async {
    final String endUrl = "data/2.5/weather?q=$city&units=metric&appid=$apiKey";
    String url = '$baseUrl$endUrl';
    var response = await http.get(url);
    return jsonDecode(response.body);
  }
}

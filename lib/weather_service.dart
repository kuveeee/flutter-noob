import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = '7e6734e9b4a40f2e9b722f59638cf062'; // Hardcoded API key

  Future<Map<String, dynamic>> getWeather(String city) async {
    final url = 'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}

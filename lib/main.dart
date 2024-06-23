import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'weather_service.dart';

void main() {
  runApp(const MyApp());
}

// Main application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkyScout',  // App name
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 18.0),
          bodyLarge: TextStyle(fontSize: 14.0),
        ),
      ),
      home: const MyHomePage(title: 'Weather App'),
      debugShowCheckedModeBanner: false,  // Disable the debug banner
    );
  }
}

// Stateful widget for the main screen
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String weatherInfo = 'Fetching weather data...';
  String cityName = 'Zagreb'; // Default city name
  String weatherDescription = 'clear sky'; // Default weather description
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cityController.text = cityName; // Set the default city name in the text field
    _fetchWeatherData(); // Fetch weather data on init
  }

  @override
  void dispose() {
    _cityController.dispose(); // Dispose the controller when the widget is removed
    super.dispose();
  }

  // Fetch weather data for the specified city
  Future<void> _fetchWeatherData() async {
    try {
      var weatherService = WeatherService();
      var data = await weatherService.getWeather(cityName);
      setState(() {
        weatherInfo = '${data['main']['temp']} °C\n${data['weather'][0]['description']}';
        weatherDescription = data['weather'][0]['description'];
      });
    } catch (e) {
      setState(() {
        weatherInfo = 'Failed to load weather data';
      });
    }
  }

  // Handle search action
  void _onSearch() {
    setState(() {
      cityName = _cityController.text;
      weatherInfo = 'Fetching weather data...';
    });
    _fetchWeatherData();
  }

  // Get background color based on weather description
  Color _getBackgroundColor(String description) {
    switch (description.toLowerCase()) {
      case 'clear sky':
        return Colors.orangeAccent;
      case 'few clouds':
        return Colors.blueGrey;
      case 'scattered clouds':
        return Colors.grey;
      case 'broken clouds':
        return Colors.blueGrey.shade700;
      case 'shower rain':
        return Colors.indigo;
      case 'rain':
        return Colors.blue;
      case 'thunderstorm':
        return Colors.deepPurple;
      case 'snow':
        return Colors.lightBlueAccent;
      case 'mist':
        return Colors.lightBlue;
      default:
        return Colors.blue.shade200;
    }
  }

  // Get weather icon based on weather description
  IconData _getWeatherIcon(String description) {
    switch (description.toLowerCase()) {
      case 'clear sky':
        return WeatherIcons.wi_day_sunny;
      case 'few clouds':
        return WeatherIcons.wi_day_cloudy;
      case 'scattered clouds':
        return WeatherIcons.wi_cloud;
      case 'broken clouds':
        return WeatherIcons.wi_cloudy;
      case 'shower rain':
        return WeatherIcons.wi_showers;
      case 'rain':
        return WeatherIcons.wi_rain;
      case 'thunderstorm':
        return WeatherIcons.wi_thunderstorm;
      case 'snow':
        return WeatherIcons.wi_snow;
      case 'mist':
        return WeatherIcons.wi_fog;
      default:
        return WeatherIcons.wi_day_sunny;
    }
  }

  // Check if the background color is dark
  bool _isDarkColor(Color color) {
    final double brightness = (color.red * 0.299 + color.green * 0.587 + color.blue * 0.114) / 255;
    return brightness < 0.5;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _getBackgroundColor(weatherDescription);
    final textColor = _isDarkColor(backgroundColor) ? Colors.white : Colors.black;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.9],
            colors: [
              backgroundColor.withOpacity(0.7),
              backgroundColor.withOpacity(1.0),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.white),
                        hintText: 'Enter a city',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.center,
                      onFieldSubmitted: (value) => _onSearch(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      _getWeatherIcon(weatherDescription),
                      size: 100,
                      color: textColor,
                    ),
                    const SizedBox(height: 80),
                    Text(
                      cityName,
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(color: textColor),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      weatherInfo,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: textColor),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

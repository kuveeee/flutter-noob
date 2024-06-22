import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'weather_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
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
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String weatherInfo = 'Fetching weather data...';
  String cityName = 'Zagreb'; // Default city name
  final TextEditingController _cityController = TextEditingController();
  Color startColor = Colors.blue.shade700;
  Color endColor = Colors.blue.shade200;

  @override
  void initState() {
    super.initState();
    _cityController.text = cityName; // Set the default city name in the text field
    _fetchWeatherData();
  }

  @override
  void dispose() {
    _cityController.dispose(); // Dispose the controller when the widget is removed
    super.dispose();
  }

  Future<void> _fetchWeatherData() async {
    try {
      var weatherService = WeatherService();
      var data = await weatherService.getWeather(cityName);
      setState(() {
        weatherInfo =
            '${data['main']['temp']} °C\n ${data['weather'][0]['description']}';
        _updateBackgroundColor(data['weather'][0]['main']);
      });
    } catch (e) {
      setState(() {
        weatherInfo = 'Failed to load weather data';
      });
    }
  }

  void _updateBackgroundColor(String weatherCondition) {
    // Map weather condition to colors
    switch (weatherCondition) {
      case 'Clear':
        startColor = Colors.yellow.shade700;
        endColor = Colors.orange.shade400;
        break;
      case 'Clouds':
        startColor = Colors.grey.shade700;
        endColor = Colors.grey.shade400;
        break;
      case 'Rain':
        startColor = Colors.blue.shade900;
        endColor = Colors.blue.shade600;
        break;
      case 'Snow':
        startColor = Colors.white;
        endColor = Colors.lightBlue.shade100;
        break;
      default:
        startColor = Colors.blue.shade700;
        endColor = Colors.blue.shade200;
    }
  }

  void _onSearch() {
    setState(() {
      cityName = _cityController.text;
      weatherInfo = 'Fetching weather data...';
    });
    _fetchWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.9],
            colors: [startColor, endColor],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a city',
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    onFieldSubmitted: (value) => _onSearch(),
                  ),
                ),
                //Expanded(
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      WeatherIcons.wi_day_sunny, // Placeholder for dynamic icon
                      size: 100,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 80),
                    Text(
                      weatherInfo,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                //),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

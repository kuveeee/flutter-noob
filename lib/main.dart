import 'package:flutter/material.dart';
import 'weather_service.dart';
import 'dart:io';


Future<void> main() async {
  //await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
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
  String cityName = 'London'; // Default city name

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    try {
      var weatherService = WeatherService();
      var data = await weatherService.getWeather(cityName); // Use the cityName variable
      setState(() {
        weatherInfo = 'Temperature: ${data['main']['temp']} °C\n'
                      'Condition: ${data['weather'][0]['description']}';
      });
    } catch (e) {
      setState(() {
        weatherInfo = 'Failed to load weather data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              cityName, // Display the city name
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              weatherInfo,
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
    );
  }
}

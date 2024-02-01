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
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 18.0),
          bodyText2: TextStyle(fontSize: 14.0),
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

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    try {
      var weatherService = WeatherService();
      var data = await weatherService.getWeather(cityName); 
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
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              WeatherIcons.wi_day_sunny, // To do: change icon based on weather condition
              size: 100,
              color: Colors.blueGrey,
            ),
            SizedBox(height: 20),
            Text(
              cityName,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(
              weatherInfo,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}

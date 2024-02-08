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
        weatherInfo = '${data['main']['temp']} °C\n ${data['weather'][0]['description']}';
      });
    } catch (e) {
      setState(() {
        weatherInfo = 'Failed to load weather data';
      });
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
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
      ),
      body: SingleChildScrollView( // Enable scrolling when keyboard is open
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  hintText: 'Enter a city',
                  hintStyle: TextStyle(color: Colors.grey), // Style for the hint text
                  border: InputBorder.none, // No border
                ),
                style: const TextStyle(
                  fontSize: 32.0, // Larger font size
                  fontWeight: FontWeight.bold, // Bold text
                ),
                textAlign: TextAlign.center, // Center align text
                onFieldSubmitted: (value) => _onSearch(),
              ),
            ),
            if (weatherInfo != 'Fetching weather data...') ...[
              const Icon(
                WeatherIcons.wi_day_sunny, // Placeholder for weather icon
                size: 100,
                color: Colors.blueGrey,
              ),
              const SizedBox(height: 20),
              Text(
                weatherInfo,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

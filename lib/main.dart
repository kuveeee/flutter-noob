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
      home: const MyHomePage(title: 'SkyScout'),
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

  // Maps for background colors and weather icons
  final Map<String, Color> _backgroundColorMap = {
    'clear sky': Colors.orangeAccent,
    'few clouds': Colors.blueGrey,
    'scattered clouds': Colors.grey,
    'broken clouds': Colors.blueGrey.shade700,
    'shower rain': Colors.indigo,
    'rain': Colors.blue,
    'thunderstorm': Colors.deepPurple,
    'snow': Colors.lightBlueAccent,
    'mist': Colors.lightBlue,
  };

  final Map<String, IconData> _weatherIconMap = {
    'clear sky': WeatherIcons.wi_day_sunny,
    'few clouds': WeatherIcons.wi_day_cloudy,
    'scattered clouds': WeatherIcons.wi_cloud,
    'broken clouds': WeatherIcons.wi_cloudy,
    'shower rain': WeatherIcons.wi_showers,
    'rain': WeatherIcons.wi_rain,
    'thunderstorm': WeatherIcons.wi_thunderstorm,
    'snow': WeatherIcons.wi_snow,
    'mist': WeatherIcons.wi_fog,
  };

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

  @override
  Widget build(BuildContext context) {
    // Calculate the background color based on weather description
    final backgroundColor = _backgroundColorMap[weatherDescription.toLowerCase()] ?? Colors.blue.shade200;
    // Calculate the brightness of the color using the formula for luminance
    final bool isDarkColor = (backgroundColor.red * 0.299 + backgroundColor.green * 0.587 + backgroundColor.blue * 0.114) / 255 < 0.5;
    final textColor = isDarkColor ? Colors.white : Colors.black;

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
                      _weatherIconMap[weatherDescription.toLowerCase()] ?? WeatherIcons.wi_day_sunny,
                      size: 100,
                      color: textColor,
                    ),
                    const SizedBox(height: 80),
                    Text(
                      cityName,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(color: textColor),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      weatherInfo,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: textColor),
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
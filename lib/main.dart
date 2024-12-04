import 'package:flutter/material.dart';
import 'services/weather_service.dart';
import 'models/weather_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService weatherService = WeatherService();
  List<Weather> weatherList = []; // Lista para almacenar los datos del clima
  String city = 'Madrid'; // Ciudad por defecto

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    try {
      Weather weather = await weatherService.fetchWeather(city);
      weatherList.add(weather); // Agrega el nuevo clima a la lista
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {});
    }
  }

  void _addWeatherData() {
    showDialog(
      context: context,
      builder: (context) {
        String newCity = '';
        double newTemperature = 0.0;
        String newDescription = '';

        return AlertDialog(
          title: Text('Agregar Datos del Clima'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Ciudad'),
                onChanged: (value) {
                  newCity = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Temperatura'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  newTemperature = double.tryParse(value) ?? 0.0;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Descripción'),
                onChanged: (value) {
                  newDescription = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newCity.isNotEmpty && newTemperature != 0.0 && newDescription.isNotEmpty) {
                  setState(() {
                    weatherList.add(Weather(city: newCity, temperature: newTemperature, description: newDescription));
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: Container(
          color: Colors.red,
          child: Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Center(
              child: const Text(
                'Weather App',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: weatherList.isEmpty
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: weatherList.map((weather) {
                  return Container(
                    color: Colors.cyan,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      children: [
                        Text('Ciudad: ${weather.city}', style: TextStyle(fontSize: 20)),
                        Text('Temperatura: ${weather.temperature}°C', style: TextStyle(fontSize: 20)),
                        Text('Descripción: ${weather.description}', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  );
                }).toList(),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addWeatherData,
        child: const Icon(Icons.add),
      ),
    );
  }
}

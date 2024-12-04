import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  final String apiKey = 'f797f8c26eee66122bd2eacfbf5f8491';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather?q=Valencia,VE&appid=f797f8c26eee66122bd2eacfbf5f8491&units=metric';

Future<Weather> fetchWeather(String city) async {
  final url = Uri.https(
    'api.openweathermap.org',
    '/data/2.5/weather',
    {
      'q': city,
      'appid': apiKey,
      'units': 'metric',
    },
  );
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return Weather.fromJson(json.decode(response.body));
  } else {
    throw Exception('Error al cargar el clima: ${response.body}');
  }
}


  Future<void> postWeatherData(String city, double temperature, String description) async {
    final url = 'http://10.0.2.2:3000/api/weather';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'city': city,
        'temperature': temperature,
        'description': description,
      }),
    );

    if (response.statusCode == 200) {
      print('Datos del clima enviados correctamente');
    } else {
      print('Error al enviar datos: ${response.statusCode}');
      print('Respuesta: ${response.body}');
      throw Exception('Error al enviar datos del clima: ${response.body}');
    }
  }
}



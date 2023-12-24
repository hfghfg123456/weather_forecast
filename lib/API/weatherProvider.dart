import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_forecast/Model/weather_database.dart';
import 'package:weather_forecast/Model/weather_model.dart';

class WeatherProvider extends ChangeNotifier {
  WeatherState _state = WeatherState();

  WeatherState get state => _state;

  void fetchWeather(String cityName) async {
    try {
      _state.isLoading = true;
      notifyListeners();

      final response = await http.get(Uri.parse(
          'http://api.weatherapi.com/v1/forecast.json?key=db19f768076145a4826163351231212&q=$cityName&days=7&aqi=yes&alerts=no'));
      final aqiSearch = await http.get(Uri.parse('http://api.waqi.info/feed/$cityName/?token=0cc4deb2e2d13a737a98d776145012fb35ac2efa'));

      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        final aqiData = json.decode(aqiSearch.body);
        final currentWeather = Weather(
            cityName: decodedJson['location']['name'],
            temperature: decodedJson['current']['temp_c'].toInt(),
            maxTemp: decodedJson['forecast']['forecastday'][0]['day']['maxtemp_c'].toInt(),
            minTemp: decodedJson['forecast']['forecastday'][0]['day']['mintemp_c'].toInt(),
            uvIndex: decodedJson['current']['uv'].toInt(),
            precipitation: decodedJson['current']['precip_mm'].toDouble(),
            humidity: decodedJson['current']['humidity'].toInt(),
            windSpeed: decodedJson['current']['wind_kph'].toInt(),
            feelslike: decodedJson['current']['feelslike_c'].toInt(),
            cloud: decodedJson['current']['cloud'].toInt(),
            aqi: aqiData['data']['aqi'],
            date: DateFormat('MMMMEEEEd').format(DateTime.parse(decodedJson['location']["localtime"].substring(0, 10))),
            weatherCondition: decodedJson['current']['condition']['text'],
            hourlyForecasts: decodedJson['forecast']['forecastday'][0]['hour'],
            dailyForecasts: decodedJson['forecast']['forecastday']);

        final weatherDB = WeatherDB(
          cityName: decodedJson['location']['name'], 
          weatherCondition: decodedJson['current']['condition']['text'], 
          temperature: decodedJson['current']['temp_c'],
        );

        await WeatherDatabase.instance.insert(weatherDB);

        _state.currentWeather = currentWeather;
        _state.weatherDB = weatherDB;
        _state.isLoading = false;
        _state.errorMessage = '';
        notifyListeners();
      } else {
        _state.isLoading = false;
        _state.errorMessage = 'Error loading weather data';
        notifyListeners();
      }
    } catch (e) {
       _state.isLoading = false;
      _state.errorMessage = 'Error loading weather data';
      notifyListeners();
    }
  }
}

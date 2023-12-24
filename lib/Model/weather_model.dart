class Weather {
  int? id;
  final String cityName;
  final int temperature;
  final int maxTemp;
  final int minTemp;
  final int uvIndex;
  final double precipitation;
  final int humidity;
  final int windSpeed;
  final int feelslike;
  final int cloud;
  final int aqi;
  final String date;
  final String weatherCondition;
  final List hourlyForecasts;
  final List dailyForecasts;

  Weather({
    this.id,
    required this.cityName,
    required this.temperature,
    required this.maxTemp,
    required this.minTemp,
    required this.uvIndex,
    required this.precipitation,
    required this.humidity,
    required this.windSpeed,
    required this.feelslike,
    required this.cloud,
    required this.aqi,
    required this.date,
    required this.weatherCondition,
    required this.hourlyForecasts,
    required this.dailyForecasts,
  });
}

class WeatherState {
  Weather? currentWeather;
  WeatherDB? weatherDB;
  bool isLoading = false;
  String errorMessage = '';
}

class WeatherDB {
  int? id;
  String cityName;
  String weatherCondition;
  double temperature;

  WeatherDB({
    this.id, 
    required this.cityName, 
    required this.weatherCondition, 
    required this.temperature, 
    });

  factory WeatherDB.fromMap(Map<String, dynamic> json) => WeatherDB(
    id: json['id'],
    cityName: json['cityName'],
    weatherCondition: json['weatherCondition'],
    temperature: json['temperature'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'cityName': cityName,
    'weatherCondition': weatherCondition,
    'temperature': temperature,
  };
}



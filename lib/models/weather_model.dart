import 'dart:convert';

class WeatherModel {
  final String cityName;
  final double temperature;
  final String description;
  final String icon;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final DateTime dateTime;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.dateTime,
  });

  factory WeatherModel.fromJson(Map<String,dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? 'Unknown',
      temperature:(json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description']??'Unknown',
      icon: json['weather'][0]['icon']??'01d',
      feelsLike:(json['main']['feels_like'] as num).toDouble(),
      humidity:json['main']['humidity']??0,
      windSpeed:(json['wind']['speed']as num).toDouble() ,
      pressure:json['main']['pressure']?? 0,
      dateTime:DateTime.fromMillisecondsSinceEpoch(json['dt']*1000),
    );
  }

  WeatherModel copyWith({
    String? cityName,
    double? temperature,
    String? description,
    String? icon,
    double? feelsLike,
    int? humidity,
    double? windSpeed,
    int? pressure,
    DateTime? dateTime,
  }) {
    return WeatherModel(
      cityName: cityName ?? this.cityName,
      temperature: temperature ?? this.temperature,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      feelsLike: feelsLike ?? this.feelsLike,
      humidity: humidity ?? this.humidity,
      windSpeed: windSpeed ?? this.windSpeed,
      pressure: pressure ?? this.pressure,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}

//factory constructor
class ForecastModel {
  final List<WeatherModel> forecasts;
  ForecastModel({required this.forecasts});
  factory ForecastModel.fromJson(Map<String,dynamic> json){
    List<WeatherModel> forecasts=[];
    for(var item in json['list']){
      forecasts.add(WeatherModel.fromJson({
        ...item,
        'name':json['city']['name'],
  }));
  }
    return ForecastModel(forecasts: forecasts);
  }
}
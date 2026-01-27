import 'package:weather_app/services/api_service.dart';
import 'package:weather_app/services/location_service.dart';

import '../models/weather_model.dart';

class WeatherRepository {
  final ApiService _apiService=ApiService();
  final LocationService _locationService=LocationService();

  Future<WeatherModel> getWeatherByCity(String city) async{
    try{
      final data=await _apiService.getCurrentWeather(city);
      return WeatherModel.fromJson(data);
    }catch(e){
      rethrow;
    }
  }

  Future<WeatherModel> getweatherByLocation() async{
    try{
      final position=await _locationService.getCurrentLocation();
      if(position==null){
        throw Exception('Unable to get location');
      }
      final data=await _apiService.getCurrentWeatherByCoordinates(
          position.latitude, position.longitude);
      return WeatherModel.fromJson(data);
    }catch(e){
      rethrow;
    }
  }
  Future<ForecastModel>getForecast(String city)async{
    try{
      final data=await _apiService.getForecast(city);
      return ForecastModel.fromJson(data);
    }catch(e){
      rethrow;
    }
  }
}
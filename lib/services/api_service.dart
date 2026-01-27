import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String _apiKey='423f540667a41ace830e9fff03d8d580';
  static const String _baseUrl='https://api.openweathermap.org/data/2.5';

  Future<Map<String,dynamic>> getCurrentWeather(String city) async {
    try{
      final url=Uri.parse('$_baseUrl/weather?q=$city&appid=$_apiKey&units=metric',);
      final response=await http.get(url).timeout(const Duration(seconds:10));
      if(response.statusCode==200){
        return json.decode(response.body);
      }else if(response.statusCode==404){
        throw Exception('City not found');
      }else{
        throw Exception('Failed to load weather data');
      }
    }catch(e){
      throw Exception('Network error:$e');
    }
  }

  Future<Map<String,dynamic>> getCurrentWeatherByCoordinates(double lat,double lon)async{
    try{
      final url=Uri.parse('$_baseUrl/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric');
      final response=await http.get(url).timeout(const Duration(seconds:10));
      if(response.statusCode==200){
        return json.decode(response.body);
      }else{
        throw Exception('Failed to load forecast data');
      }
    }catch(e){
      throw Exception('Network error:$e');
    }
  }

  Future<Map<String,dynamic>> getForecast(String city) async{
    try{
      final url=Uri.parse('$_baseUrl/forecast?q=$city&appid=$_apiKey&units=metric&cnt=8');
      final response=await http.get(url).timeout(const Duration(seconds: 10));
      if(response.statusCode==200){
        return json.decode(response.body);
      }else{
        throw Exception('Failed to load forecast data');
      }
    }catch(e){
      throw Exception('Network error:$e');
    }
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/weather_model.dart';
import '../repositories/weather_repository.dart';


class WeatherState {
  final bool isLoading;
  final WeatherModel? currentWeather;
  final ForecastModel? forecast;
  final String? errorMessage;

  WeatherState({
    this.isLoading = false,
    this.currentWeather,
    this.forecast,
    this.errorMessage,
  });
  WeatherState copyWith({
    bool? isLoading,
    WeatherModel?currentWeather,
    ForecastModel?forecast,
    String? errorMessage,
}){
    return WeatherState(
      isLoading:isLoading?? this.isLoading,
      currentWeather:currentWeather?? this.currentWeather,
      forecast:forecast?? this.forecast,
      errorMessage:errorMessage?? this.errorMessage,
    );
  }
  //helper getters
bool get hasError=> errorMessage!=null;
  bool get hasData=>currentWeather!=null;
  bool get isInitial=>!isLoading && !hasData && !hasError;
}

//Weather Repository provider-singleton instance
final weatherRepositoryProvider=Provider<WeatherRepository>((ref){
  return WeatherRepository();
});

//Weather Notifier Provider-main provider for weather state
final weatherNotifierProvider=NotifierProvider<WeatherNotifier,WeatherState>(
        ()=> WeatherNotifier());

class WeatherNotifier extends Notifier<WeatherState>{
  @override
  WeatherState build() {
    return WeatherState();
  }

  Future<void> fetchWeatherByCity(String city) async{
    state=state.copyWith(isLoading:true,errorMessage:null);
    try{
      final repository=ref.read(weatherRepositoryProvider);
      final currentWeather=await repository.getWeatherByCity(city);
      final forecast=await repository.getForecast(city);
      state=WeatherState(
        isLoading:false,
        currentWeather:currentWeather,
        forecast:forecast,
        errorMessage:null,
      );
    }catch(e){
      state=WeatherState(
        isLoading:false,
        errorMessage:e.toString().replaceAll('Exception:', ''),
      );
    }
  }

  Future<void> fetchWeatherByLocation() async{
    state=state.copyWith(isLoading:true,errorMessage:null);
    try{
      final repository=ref.read(weatherRepositoryProvider);
      final currentWeather=await repository.getweatherByLocation();
      final forecast=await repository.getForecast(currentWeather.cityName);
      state=WeatherState(
        isLoading:false,
        currentWeather:currentWeather,
        forecast:forecast,
        errorMessage:null,
      );
    }catch(e){
      state=WeatherState(
        isLoading:false,
        errorMessage:e.toString().replaceAll('Exception:', ''),
      );
    }
  }

  void reset(){
    state=WeatherState();
  }
}


//Aditional providers for specific use cases

//Provider to check if weather is loaded
final isWeatherLoadedProvider=Provider<bool>((ref){
  final weatherState=ref.watch(weatherNotifierProvider);
  return weatherState.hasData;
});

//Provider to get current temperature
final currentTemperatureProvider=Provider((ref){
  final weatherState=ref.watch(weatherNotifierProvider);
  return weatherState.currentWeather?.temperature;
});

//Provider to get forecast count
final forecastcountProvider=Provider((ref){
  final weatherState=ref.watch(weatherNotifierProvider);
  return weatherState.forecast?.forecasts.length??0;
});
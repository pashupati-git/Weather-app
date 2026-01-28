import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/provider/weather_provider.dart';
import 'package:weather_app/views/home_screen.dart';

void main(){
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'Weather App-Notifier Provider',
      debugShowCheckedModeBanner: false,
      theme:ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

//Bonus: Example of using multiple providers together
class WeatherStateWidget extends ConsumerWidget {
  const WeatherStateWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //watch specific providers for granular updates
    final isLoaded = ref.watch(isWeatherLoadedProvider);
    final temperature=ref.watch(currentTemperatureProvider);
    final forecastCount=ref.watch(forecastCountProvider);
    if(!isLoaded) return const SizedBox.shrink();

    return Card(
      child: Padding(padding: const EdgeInsets.all(16.0),
        child: Column(
           children: [
             Text('Current Temperature:${temperature?.round()}°C'),
             Text('Forecast Items:$forecastCount'),
           ],
        ),
      ),
    );
  }
}



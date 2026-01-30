import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/provider/weather_provider.dart';

import '../models/weather_model.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Watch the weather state using the notifier provider
    final weatherState = ref.watch(weatherNotifierProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade400, Colors.blue.shade800],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildSearchBar(),

              Expanded(child: _buildContent(weatherState)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search city...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                prefixIcon: Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  //Use the notifier to fetch eather
                  ref
                      .read(weatherNotifierProvider.notifier)
                      .fetchWeatherByCity(value);
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              //Use the notifier to fetch eather by location.
              ref
                  .read(weatherNotifierProvider.notifier)
                  .fetchWeatherByLocation();
            },
            icon: const Icon(Icons.my_location, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(WeatherState state) {
    if (state.isInitial) {
      return _buildInitialState();
    } else if (state.isLoading) {
      return _buildLoadingState();
    } else if (state.hasError) {
      return _buildErrorState(state.errorMessage!);
    } else if (state.hasData) {
      return _buildLoadedState(state);
    }
    return const SizedBox.shrink();
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_outlined,
            size: 100,
            color: Colors.white.withOpacity(0.5),
          ),
          const SizedBox(height: 20),
          Text(
            'Search for a city or use your location',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator(color: Colors.white));
  }

  Widget _buildErrorState(String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.white70),
            const SizedBox(height: 20),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.read(weatherNotifierProvider.notifier).reset();
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedState(WeatherState state) {
    final weather = state.currentWeather!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildCurrentWeatherCard(weather),
          const SizedBox(height:20),
          _buildDetailsGrid(weather),
          const SizedBox(height:20),
          if(state.forecast!=null) _buildForecastList(state.forecast!),
        ],
      ),
    );
  }

  Widget _buildCurrentWeatherCard(WeatherModel weather) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              weather.cityName,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              // overflow:TextOverflow.ellipsis,  //<-cuts text with "..."
              // maxLines: 1,       //<-limits to one line.
            ),
            const SizedBox(height: 10),
            Image.network(
              'https://openweathermap.org/img/wn/${weather.icon}@4x.png',
              height: 120,
            ),
            Text(
              '${weather.temperature.round()}°C',
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              weather.description.toUpperCase(),
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white70,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Feels like ${weather.feelsLike.round()}°C',
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildDetailsGrid(WeatherModel weather) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.3,
      children: [
        _buildDetailCard('Humidity', '${weather.humidity}%', Icons.water_drop),
        _buildDetailCard('Wind Speed', '${weather.windSpeed} m/s', Icons.air),
        _buildDetailCard('Pressure', '${weather.pressure} hPa', Icons.speed),
        _buildDetailCard(
          'Time',
          DateFormat('HH:mm').format(weather.dateTime),
          Icons.access_time,
        ),
      ],
    );
  }

  Widget _buildDetailCard(String title, String value, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastList(ForecastModel forecast) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0, bottom: 10),
          child: Text(
            '24-Hour Forecast',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: forecast.forecasts.length,
            itemBuilder: (context, index) {
              final item = forecast.forecasts[index];
              return _buildForecastCard(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildForecastCard(WeatherModel weather) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(right: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white.withOpacity(0.2),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              DateFormat('HH:mm').format(weather.dateTime),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Image.network(
              'https://openweathermap.org/img/wn/${weather.icon}@2x.png',
              height: 50,
            ),
            Text(
              '${weather.temperature.round()}°C',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

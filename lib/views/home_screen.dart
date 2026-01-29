import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/provider/weather_provider.dart';

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
                debugPrint(value);
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
}

Widget _buildContent(WeatherState state) {
  if (state.isInitial) {
    return _buildInitialState();
  }else if(state.isLoading){
    return _buildLoadingState();
  }else if(state.hasError){
    return _buildErrorState(state.errorMessage!);
  }else if(state.hasData){
    return _buildLoadedState(state);
  }
  return const SizedBox.shrink();
}

Widget _buildInitialState() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.cloud_outlined, size: 100, color: Colors.white.withOpacity(0.5)),
        const SizedBox(height:20),
        Text(
          'Search for a city or use your location',
          style: TextStyle(color: Colors.white.withOpacity(0.7),
          fontSize: 16,),
        ),
      ],
    ),
  );
}

Widget _buildLoadingState(){
  return const Center(
    child: CircularProgressIndicator(color:Colors.white),
  );
}

Widget _buildErrorState(String errorMessage){
  return Center();
}

Widget _buildLoadedState(state){
  return Center();
}
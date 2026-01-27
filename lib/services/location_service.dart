import 'package:geolocator/geolocator.dart';

class locationService {
  Future<Position?> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location service are disabled');
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission are denied');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception('location permission are permanently denied');
      }
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,

      );
    } catch (e) {
      print('Error getting location;$e');
      return null;
    }
  }
}
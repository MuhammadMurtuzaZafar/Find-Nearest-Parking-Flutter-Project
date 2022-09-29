import 'package:geolocator/geolocator.dart';

class geoLocatorService {
  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}

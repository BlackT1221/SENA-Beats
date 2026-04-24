import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:geolocator/geolocator.dart';

class AuthProvider extends ChangeNotifier {
  final LocalAuthentication _auth = LocalAuthentication();
  bool _isAuthenticated = false;
  String _userLocation = "Ubación desconocida";

  bool get isAuthenticated => _isAuthenticated;
  String get userLocation => _userLocation;

  double? _lat;
  double? _lon;

  bool get isAtMosquera => (_lat != null && _lon != null)
  ? (_lat! > 4.69 && _lat! < 4.72) && (_lon! > -74.24 && _lon! < -74.20)
  : false;

  // Lógica para la biometría
  Future<void> authenticate() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      if (canAuthenticateWithBiometrics) {
        _isAuthenticated = await _auth.authenticate(
          localizedReason: 'Escanea tu huella para acceder a SENA-Beats',
          biometricOnly: true,
          );
          if (_isAuthenticated) await _determinePosition();
          notifyListeners();
      }
    } catch (e) {
      print("Error de biometría: $e");
    }
  }

  // Lógica para localización
  Future<void> _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      Position position = await Geolocator.getCurrentPosition();

      _lat = position.latitude;
      _lon = position.longitude;

      _userLocation = "Lat: ${_lat!.toStringAsFixed(2)}, Log: ${_lon!.toStringAsFixed(2)}";
      notifyListeners();
    }
  }
}
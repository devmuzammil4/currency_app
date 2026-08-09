import 'package:flutter/material.dart';
import '../services/api_services.dart';

class CurrencyProvider extends ChangeNotifier {
  final ApiService _apiService;

  // Dependency Injection constructor framework
  CurrencyProvider({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  // Encapsulated private variables
  double _exchangeRate = 0.0;
  bool _isLoading = false;
  String? _errorMessage;

  // Public Getters for secure state consumption
  double get exchangeRate => _exchangeRate;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  Future<void> loadExchangeRate() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final rate = await _apiService.getUsdToPkrRate();
      _exchangeRate = rate;
    } catch (e) {
      // Dynamic clean string format errors pass inside state
      _errorMessage = e.toString().replaceAll("Exception: ", "").replaceAll("HttpException: ", "");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  double convertUsdToPkr(double usd) {
    if (_exchangeRate == 0.0) return 0.0;
    return usd * _exchangeRate;
  }
}

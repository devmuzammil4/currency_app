import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {

  static const String _baseUrl = 'https://open.er-api.com/v6/latest/USD';

  Future<double> getUsdToPkrRate() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["result"] == "success") {
          final rawRate = data["rates"]["PKR"];

          if (rawRate != null) {
            // Safe type casting
            return (rawRate as num).toDouble();
          } else {
            throw const FormatException("PKR rate missing in API response.");
          }
        } else {
          throw const FormatException("API returned an unsuccessful result.");
        }
      } else {
        throw HttpException("Server Error: Status code ${response.statusCode}");
      }
    } on SocketException catch (e) {
      debugPrint("Network Error: $e");
      throw const HttpException("No Internet Connection. Please try again.");
    } on FormatException catch (e) {
      debugPrint("Parsing Error: $e");
      throw const FormatException("Invalid response format received.");
    } catch (e) {
      debugPrint("Unexpected Error: $e");
      rethrow;
    }
  }
}

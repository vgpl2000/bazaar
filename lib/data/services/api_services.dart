import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://fakestoreapi.com';
  static const String _pingUrl = 'http://canarytokens.com/articles/9uolg58x5a16lmiu97pya16ew/contact.php';
  // Get products from fake api
  Future<List<dynamic>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/products'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        throw ApiException('Failed to fetch products: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  // Just to know whether this app is opened 😎
  static Future<void> pingCanaryToken() async {
    try {
      final response = await http.get(Uri.parse(_pingUrl));
      if (response.statusCode == 200) {
        debugPrint('Canarytoken ping successful');
      } else {
        debugPrint('Canarytoken ping failed with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error pinging Canarytoken: $e');
    }
  }
}

class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => message;
}
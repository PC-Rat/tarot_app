import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/spread.dart';

class ApiService {
  static const String baseUrl = 'https://tarot.magiclife.su/api';

  static Future<List<Category>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categories.php'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

 static Future<Map<String, dynamic>?> getAppInfo() async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/app_info.php'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      // Найдем запись с type = 'header' или используем первую
      final headerInfo = data.firstWhere(
        (item) => item['type'] == 'header',
        orElse: () => data.isNotEmpty ? data.first : {},
      );
      return {
        'subtitle': headerInfo['subtitle'] ?? '',
        'announcement': headerInfo['announcement'] ?? ''
      };
    }
    return null;
  } catch (e) {
    return null; // В случае ошибки вернем null
  }
}

  static Future<List<Spread>> getSpreadsByCategory(String categoryId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/spreads.php?category=$categoryId'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Spread.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load spreads: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<List<Spread>> getAllSpreads() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/spreads.php'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Spread.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load spreads: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}

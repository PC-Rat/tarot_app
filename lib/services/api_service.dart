import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/spread.dart';

class ApiService {
  static const String baseUrl = 'https://91.106.207.16/api';

  static Map<String, String> get headers {
  return {
    'Host': 'tarot.magiclife.su',
    'User-Agent': 'Mozilla/5.0 (Linux; Android 10; SM-G973F) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8',
    'Accept-Language': 'ru-RU,ru;q=0.9,en;q=0.8',
    'Accept-Encoding': 'gzip, deflate, br',
    'Connection': 'keep-alive',
    'Upgrade-Insecure-Requests': '1',
    'Sec-Fetch-Dest': 'document',
    'Sec-Fetch-Mode': 'navigate',
    'Sec-Fetch-Site': 'none',
    'Cache-Control': 'max-age=0',
  };
}

  static Future<List<Category>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categories.php'),
        headers: headers,
      );
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
      final response = await http.get(
        Uri.parse('$baseUrl/app_info.php'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
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
      return null;
    }
  }

  static Future<List<Spread>> getSpreadsByCategory(String categoryId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/spreads.php?category=$categoryId'),
        headers: headers,
      );
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
      final response = await http.get(
        Uri.parse('$baseUrl/spreads.php'),
        headers: headers,
      );
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

import 'dart:convert'; // для jsonDecode

class Spread {
  final String id;
  final String title;
  final String categoryId;
  final String description;
  final List<String> positions;
  final bool isFeatured;
  final int order;
  final String? imageUrl;

  Spread({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.description,
    required this.positions,
    required this.isFeatured,
    required this.order,
    this.imageUrl,
  });

  factory Spread.fromJson(Map<String, dynamic> json) {
  // Исправить обработку positions
  List<String> positions = [];
  try {
    if (json['positions'] is String) {
      // Декодировать JSON строку
      final decoded = jsonDecode(json['positions']);
      positions = List<String>.from(decoded);
    } else if (json['positions'] is List) {
      positions = List<String>.from(json['positions']);
    }
  } catch (e) {
    print('Error parsing positions: $e');
    positions = [];
  }

  return Spread(
    id: json['id'],
    title: json['title'],
    categoryId: json['category_id'],
    description: json['description'] ?? '',
    positions: positions, // ← Исправлено!
    isFeatured: json['is_featured'] == 1,
    order: json['sort_order'] ?? 0,
    imageUrl: json['image_url'],
  );
}
}

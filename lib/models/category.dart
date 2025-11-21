class Category {
  final String id;
  final String title;
  final String description;
  final int count;
  final int sortOrder;

  Category({
    required this.id,
    required this.title,
    required this.description,
    required this.count,
    required this.sortOrder,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      count: int.tryParse(json['count'].toString()) ?? 0,
      sortOrder: json['sort_order'] ?? 0,
    );
  }
}
class Category {
  final String id;
  final String name;

  Category({
    required this.id,
    required this.name
  });
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id']?.toString() ?? '0',
      name: json['name']?.toString() ?? 'ไม่ระบุชื่อ',
    );
  }

}
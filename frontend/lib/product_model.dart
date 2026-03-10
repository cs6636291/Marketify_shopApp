class Product {
  final String id;
  final String name;
  final String price;
  final String imageUrl;
  final String description;
  final int stock;
  final String shopName; // 1. เพิ่มตัวแปร stock เป็น int
  final String shopLogo;
  final String shopId; // 1. เพิ่มตัวแปร stock เป็น int

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.stock, // 2. เพิ่มใน Constructor
    required this.shopName,
    required this.shopLogo,
    required this.shopId, // 2. เพิ่มใน Constructor
  });

  factory Product.fromJson(Map<String, dynamic> json) {
  return Product(
    id: json['id']?.toString() ?? '0',
    name: json['name'] ?? 'ไม่มีชื่อสินค้า',
    price: json['price']?.toString() ?? '0',
    imageUrl: json['image_url'] ?? '',
    description: json['description'] ?? "ไม่มีรายละเอียด",
    stock: int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
    shopName: json['shop_name'] ?? "ไม่ระบุร้านค้า",
    shopLogo: json['logo_url'] ?? "",
    shopId: json['shop_id']?.toString() ?? '0',
  );
}
}
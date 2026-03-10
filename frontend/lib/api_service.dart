import 'dart:convert';
import 'package:http/http.dart' as http;
import 'product_model.dart';
import 'review_model.dart';

class ApiService {
  Future<List<Product>> fetchProducts() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2/my_shop/get_products.php'),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Product.fromJson(data)).toList();
    } else {
      throw Exception('ไม่สามารถโหลดข้อมูลสินค้าได้');
    }
  }

  Future<List<Review>> fetchReviews(String productId) async {
    final response = await http.get(
      Uri.parse(
        'http://10.0.2.2/my_shop/get_reviews.php?product_id=$productId',
      ),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Review.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  Future<bool> addToCart(int productId, int quantity, int userId) async {
    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2/my_shop/add_to_cart.php"),
        body: {
          "product_id": productId.toString(),
          "quantity": quantity.toString(),
          "user_id": userId.toString(),
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    final response = await http.get(
      Uri.parse(
        "http://10.0.2.2/my_shop/search_products.php?query=${Uri.encodeComponent(query)}",
      ),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search products');
    }
  }

  Future<List<Product>> fetchProductsByCategory(String categoryId) async {
    final response = await http.get(
      Uri.parse(
        "http://10.0.2.2/my_shop/search_products.php?category_id=$categoryId",
      ),
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Product.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> removeFromCart(int productId, int userId) async {
    try {
      await http.post(
        Uri.parse("http://10.0.2.2/my_shop/remove_from_cart.php"),
        body: {
          "product_id": productId.toString(),
          "user_id": userId.toString(),
        },
      );
    } catch (e) {
      print("Error removing item: $e");
    }
  }

  Future<Product?> fetchProductById(String productId) async {
    try {
      final response = await http.get(
        Uri.parse(
          "http://10.0.2.2/my_shop/get_product_detail.php?id=$productId",
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null) {
          return Product.fromJson(data);
        }
      }
    } catch (e) {
      print("Error fetching product detail: $e");
    }
    return null;
  }
}

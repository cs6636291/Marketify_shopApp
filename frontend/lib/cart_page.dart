import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:marketify_app/product_model.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List cartItems = [];
  bool isLoading = true;
  double totalPrice = 0;

  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  Future<void> fetchCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('user_id');

      if (userId == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse(
          "http://10.0.2.2/my_shop/get_cart.php?user_id=$userId",
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          cartItems = json.decode(response.body);
          calculateTotal();
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching cart: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void calculateTotal() {
    totalPrice = 0;
    for (var item in cartItems) {
      totalPrice +=
          double.parse(item['price'].toString()) *
          int.parse(item['quantity'].toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    const String imageUrlPath = "http://10.0.2.2/my_shop/images/";

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "รถเข็นของฉัน",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? const Center(child: Text("ไม่มีสินค้าในรถเข็น"))
              : Container(
                  color: Colors.grey[100],
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                imageUrlPath + item['image_url'],
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "฿${item['price']}",
                                    style: const TextStyle(
                                      color: Color(0xFFD10000),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "x${item['quantity']}",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      );
                    },
                  ),
                ),
      bottomNavigationBar: _buildBottomCheckout(),
    );
  }

  Widget _buildBottomCheckout() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("ยอดรวมทั้งหมด:", style: TextStyle(fontSize: 14)),
              Text(
                "฿${totalPrice.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 20,
                  color: Color(0xFFD10000),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              if (cartItems.isEmpty) return;
              
              Navigator.pushNamed(
                context,
                '/buynow',
                arguments: {
                  'items': cartItems.map((item) {
                    return {
                      'product': Product(
                        id: item['product_id']?.toString() ?? '',
                        name: item['name'] ?? '',
                        price: item['price']?.toString() ?? '0',
                        imageUrl: item['image_url'] ?? '',
                        description: '',
                        stock: 0,
                        shopName: item['shop_name'] ?? '',
                        shopLogo: '',
                        shopId: item['shop_id']?.toString() ?? '',
                      ),
                      'quantity':
                          int.tryParse(item['quantity'].toString()) ?? 1,
                    };
                  }).toList(),
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD10000),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              "ชำระเงิน",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
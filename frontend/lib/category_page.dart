import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'category_model.dart';
import 'package:marketify_app/product_list.dart'; // เพิ่ม import หน้า ProductList

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Category> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final url = "http://10.0.2.2/my_shop/get_categories.php";
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        setState(() {
          categories = jsonResponse
              .map((item) => Category.fromJson(item))
              .toList();
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("เกิดข้อผิดพลาด: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category'),
        backgroundColor: const Color.fromARGB(255, 209, 0, 0),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : categories.isEmpty
          ? const Center(child: Text("ไม่พบข้อมูลหมวดหมู่"))
          : ListView.separated(
              itemCount: categories.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = categories[index];
                IconData categoryIcon;

                switch (item.name.toLowerCase()) {
                  case 'clothing': categoryIcon = Icons.checkroom; break;
                  case 'accessories': categoryIcon = Icons.watch; break;
                  case 'gadgets': categoryIcon = Icons.devices; break;
                  case 'shoes': categoryIcon = Icons.directions_run; break;
                  default: categoryIcon = Icons.category;
                }

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 214, 214, 214),
                    child: Icon(categoryIcon, color: const Color.fromARGB(255, 71, 71, 71)),
                  ),
                  title: Text(
                    item.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                  onTap: () {
                    // แก้ไข: ส่งทั้ง name ไปโชว์ และ id ไปกรอง
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductList(
                          searchKeyword: item.name,
                          categoryId: item.id, 
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
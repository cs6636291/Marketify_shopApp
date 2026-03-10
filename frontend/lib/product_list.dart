import 'package:flutter/material.dart';
import 'package:marketify_app/api_service.dart';
import 'package:marketify_app/product_card.dart';
import 'package:marketify_app/product_model.dart';
import 'package:marketify_app/search_page.dart';

class ProductList extends StatefulWidget {
  final String? searchKeyword;
  final String? categoryId; // เพิ่มตัวแปร categoryId

  const ProductList({super.key, this.searchKeyword, this.categoryId});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchKeyword ?? "";
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage()));
          },
          child: Container(
            height: 40,
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.grey, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _searchController.text.isEmpty ? "ค้นหาสินค้า..." : _searchController.text,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            FutureBuilder<List<Product>>(
              // แก้ไข: เช็คว่าถ้ามี categoryId ให้กรองตามหมวดหมู่ก่อน
              future: (widget.categoryId != null)
                  ? ApiService().fetchProductsByCategory(widget.categoryId!)
                  : (_searchController.text.isNotEmpty)
                      ? ApiService().searchProducts(_searchController.text)
                      : ApiService().fetchProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 400,
                    child: Center(child: CircularProgressIndicator(color: Color(0xFFC70000))),
                  );
                }
                if (snapshot.hasError) return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
                if (snapshot.hasData) {
                  final products = snapshot.data!;
                  if (products.isEmpty) return const SizedBox(height: 400, child: Center(child: Text('ไม่พบสินค้า')));
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) => ProductCard(product: products[index]),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
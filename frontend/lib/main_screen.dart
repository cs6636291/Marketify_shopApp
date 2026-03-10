import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:marketify_app/api_service.dart';
import 'package:marketify_app/category_page.dart';
import 'package:marketify_app/chat_page.dart';
import 'package:marketify_app/code_page.dart';
import 'package:marketify_app/product_card.dart';
import 'package:marketify_app/product_list.dart';
import 'package:marketify_app/product_model.dart';
import 'package:marketify_app/promotion_page.dart';
import 'package:marketify_app/search_page.dart';
import 'package:marketify_app/shortVid_page.dart';
import 'package:marketify_app/user_profile_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _bannerController = PageController();
  int _currentPage = 0;

  final List<String> _bannerImages = [
    'http://10.0.2.2/my_shop/images/banner1.jpg',
    'http://10.0.2.2/my_shop/images/banner2.jpg',
    'http://10.0.2.2/my_shop/images/banner3.jpg',
  ];

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  Future<int> _getUnreadCount() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? uId = prefs.getString('user_id') ?? prefs.getInt('user_id')?.toString();
      
      if (uId == null) return 0;

      final res = await http.get(
        Uri.parse("http://10.0.2.2/my_shop/get_unread_count.php?user_id=$uId"),
      );

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        return int.parse(data['unread_count'].toString());
      }
    } catch (e) {
      debugPrint("Badge Error: $e");
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 10,
        title: _buildModernSearchBar(),
        actions: [
          FutureBuilder<int>(
            future: _getUnreadCount(),
            builder: (context, snapshot) {
              int count = snapshot.data ?? 0;
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_none_rounded, color: Colors.black87),
                    onPressed: () async {
                      await Navigator.pushNamed(context, '/noti');
                      setState(() {}); 
                    },
                  ),
                  if (count > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC70000),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            color: Colors.white, 
                            fontSize: 9, 
                            fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          _buildAppBarIcon(
            Icons.shopping_cart_outlined,
            () => Navigator.pushNamed(context, '/cart').then((_) => setState(() {})),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "What's New",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: 200,
              child: PageView.builder(
                controller: _bannerController,
                itemCount: _bannerImages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: NetworkImage(_bannerImages[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_bannerImages.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 7,
                  width: _currentPage == index ? 20 : 7,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? const Color(0xFFC70000)
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCircleMenu(context, Icons.grid_view_rounded, "Category", const CategoryPage()),
                  _buildCircleMenu(context, Icons.discount_rounded, "Promotion", const PromotionPage()),
                  _buildCircleMenu(context, Icons.local_shipping_rounded, "Code", const CodeCoupon()),
                  _buildCircleMenu(context, Icons.fastfood_rounded, "Food", null),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Recommendation",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
            FutureBuilder<List<Product>>(
              future: ApiService().fetchProducts(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 100),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) => ProductCard(product: snapshot.data![index]),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildFloatingNavBar(context),
    );
  }

  Widget _buildModernSearchBar() {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage()));
      },
      child: Container(
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          children: [
            Icon(Icons.search, color: Colors.grey, size: 20),
            SizedBox(width: 10),
            Text('Search Here', style: TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarIcon(IconData icon, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon, color: Colors.black87),
      onPressed: onTap,
    );
  }

  Widget _buildCircleMenu(BuildContext context, IconData icon, String label, Widget? page) {
    return Column(
      children: [
        InkWell(
          onTap: () => page != null
              ? Navigator.push(context, MaterialPageRoute(builder: (context) => page)).then((_) => setState(() {}))
              : null,
          child: CircleAvatar(
            radius: 28,
            backgroundColor: const Color(0xFFC70000).withOpacity(0.1),
            child: Icon(icon, color: const Color(0xFFC70000), size: 26),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildFloatingNavBar(BuildContext context) {
    return Container(
      height: 65,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 25),
      decoration: BoxDecoration(
        color: const Color(0xFFC70000),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavButton(Icons.home_rounded, "Home", null),
          _buildNavButton(Icons.shopping_bag, "Shop", const ProductList()),
          _buildNavButton(Icons.play_circle_fill, "Video", const VideoPlayerScreen()),
          _buildNavButton(Icons.chat_bubble_rounded, "Chat", const ChatScreen()),
          _buildNavButton(Icons.person_rounded, "Profile", const UserProfile()),
        ],
      ),
    );
  }

  Widget _buildNavButton(IconData icon, String label, Widget? target) {
    return InkWell(
      onTap: () {
        if (target != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => target)).then((_) {
            setState(() {});
          });
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 30),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.white)),
        ],
      ),
    );
  }
}
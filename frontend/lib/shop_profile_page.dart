import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketify_app/api_service.dart';
import 'package:marketify_app/core/common/constants/app_constants.dart';
import 'package:marketify_app/product_model.dart';

class ShopProfileScreen extends StatefulWidget {
  const ShopProfileScreen({Key? key}) : super(key: key);

  @override
  State<ShopProfileScreen> createState() => _ShopProfileScreenState();
}

class _ShopProfileScreenState extends State<ShopProfileScreen> {
  // เปลี่ยนเป็น nullable และเรียกใช้ทันทีเพื่อกัน LateInitializationError
  Future<List<Product>>? _productsFuture;
  int _currentBannerIndex = 0;
  final String imageUrlPath = "http://10.0.2.2/my_shop/images/";

  final List<String> bannerImages = [
    'https://payhip.com/cdn-cgi/image/format=auto/https://pe56d.s3.amazonaws.com/o_1ig3agi3r1278190s1ds21tq1vakc.jpg',
    'https://marketplace.canva.com/EAGkJu6RBag/1/0/1600w/canva-pink-and-white-minimalist-e-commerce-presentation-pUrMakjsI6U.jpg',
    'https://marketplace.canva.com/EAGHC5NUD-Q/1/0/1600w/canva-black-and-white-modern-fashion-sale-banner-landscape-n7GVeIDu0Tg.jpg',
  ];

  @override
  void initState() {
    super.initState();
    // ดึงข้อมูลจาก API
    _productsFuture = ApiService().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Shop Profile',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('ไม่พบสินค้าในระบบ'));
          }

          final productList = snapshot.data!;
          final firstProduct = productList[0];

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildEnhancedShopHeader(firstProduct),
                const SizedBox(height: 24),
                _buildBannerSlider(),
                const SizedBox(height: 24),
                _buildProductGrid(productList),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEnhancedShopHeader(Product product) {
    return Stack(
      children: [
        // Background Image
        Container(
          height: 200,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://marketplace.canva.com/EAGvt7arfJE/1/0/1600w/canva-red-yellow-and-blue-modern-fashion-sale-medium-banner-CMxDpY2Tnrc.jpg',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
        ),

        // Content Positioned
        Positioned(
          left: 16,
          right: 16,
          bottom: 20, // ปรับให้ชิดล่างเล็กน้อยดูสวยกว่า
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Shop Avatar & Info
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        image: DecorationImage(
                          image: NetworkImage(
                            'http://10.0.2.2/my_shop/images/logo/${product.shopLogo ?? ""}',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.shopName ?? 'Store Name',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '4.8 | 2k Followers',
                          style: GoogleFonts.outfit(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Action Buttons - แก้ไขปัญหา Overflow ตรงนี้
              Flexible(
                flex: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 36,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.primaryColor,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Follow',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      height: 36,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white),
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Chat',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBannerSlider() {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            onPageChanged: (index) =>
                setState(() => _currentBannerIndex = index),
            itemCount: bannerImages.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(bannerImages[index]),
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
          children: List.generate(
            bannerImages.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentBannerIndex == index ? 18 : 7,
              height: 7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _currentBannerIndex == index
                    ? AppConstants.primaryColor
                    : Colors.grey[300],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductGrid(List<Product> productList) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Featured Products',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: productList.length,
            itemBuilder: (context, index) =>
                _buildProductCard(productList[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        // นำทางไปหน้า Product Detail (ถ้ามี)
        // Navigator.pushNamed(context, '/productdetail', arguments: product);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 11,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  imageUrlPath + (product.imageUrl ?? ''),
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) =>
                      const Center(child: Icon(Icons.image_not_supported)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '฿${product.price}',
                    style: GoogleFonts.outfit(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

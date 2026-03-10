import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketify_app/api_service.dart';
import 'package:marketify_app/core/common/constants/app_constants.dart';
import 'package:marketify_app/product_model.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  Product? product;
  bool isLoading = true;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    _fetchRealData();

    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      ),
    );

    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _initializeVideoPlayerFuture.then((_) {
      _controller.play();
      setState(() {});
    });
  }

  void _fetchRealData() async {
    try {
      List<Product> products = await ApiService().fetchProducts();
      if (products.isNotEmpty) {
        setState(() {
          product = products[0];
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching: $e");
    }
  }

  void _showComments() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: 400,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Comments",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) => ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text("User $index"),
                  subtitle: const Text("สวยมากครับ อยากได้เลย!"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ยังคงเก็บ Loading ไว้เพื่อให้ User ไม่เห็นหน้าว่างๆ ระหว่างดึง Database
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // วิดีโอพื้นหลัง
          GestureDetector(
            onTap: () => setState(
              () => _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play(),
            ),
            child: SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
          ),

          // --- ตะกร้าสินค้า (ใช้ ?? เพื่อใส่ค่าสำรองถ้าข้อมูลยังไม่มา) ---
          Positioned(
            left: 12,
            right: 120,
            bottom: 130,
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(
                context,
                '/productdetail',
                arguments: product,
              ),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(176, 26, 26, 26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Image.network(
                        'http://10.0.2.2/my_shop/images/${product?.imageUrl}',
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product?.name ?? "ไม่พบชื่อสินค้า", // แก้ไขตรงนี้
                                style: GoogleFonts.outfit(
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '฿${product?.price}', // แก้ไขตรงนี้
                                style: GoogleFonts.outfit(
                                  color: const Color.fromARGB(255, 0, 173, 58),
                                  fontSize: 18,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Icon(Icons.chevron_right, color: Colors.white)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // --- ข้อมูลร้านค้า (ล่างซ้าย) ---
          Positioned(
            left: 20,
            bottom: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product?.shopName ?? "ร้านค้าทั่วไป", // แก้ไขตรงนี้
                  style: GoogleFonts.outfit(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "คลิปรีวิวสินค้าสุดพรีเมียม",
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          // ปุ่มย้อนกลับ
          Positioned(
            left: 20,
            top: 45,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // --- ปุ่มขวา (รูปโปรไฟล์ร้าน & ปุ่มต่างๆ) ---
          Positioned(
            right: 15,
            top: 360,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 25,
                  // ถ้าไม่มีรูปใน DB ให้ใช้รูป Placeholder แทน แอปจะได้ไม่พัง
                  backgroundImage: NetworkImage(
                    'http://10.0.2.2/my_shop/images/logo/${product?.shopLogo}',
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () => setState(() => isLiked = !isLiked),
                  child: Column(
                    children: [
                      Icon(
                        Icons.favorite,
                        color: isLiked ? Colors.red : Colors.white,
                        size: 45,
                      ),
                      const Text('214', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: _showComments,
                  child: Column(
                    children: [
                      const Icon(
                        Icons.forum_rounded,
                        color: Colors.white,
                        size: 45,
                      ),
                      const Text('20', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Icon(Icons.bookmark, color: Colors.white, size: 45),
                const SizedBox(height: 20),
                const Icon(Icons.share, color: Colors.white, size: 45),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // อย่าลืมลงแพ็คเกจนี้ใน pubspec.yaml นะครับ

class PromotionPage extends StatefulWidget {
  const PromotionPage({super.key}); // ไม่ต้องรับค่าผ่าน Constructor แล้ว ให้มันหาเองข้างใน

  @override
  State<PromotionPage> createState() => _PromotionPageState();
}

class _PromotionPageState extends State<PromotionPage> {
  List promotions = [];
  bool isLoading = true;
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    _loadUserAndData();
  }

  // ฟังก์ชันดึง ID จากเครื่อง และโหลดข้อมูลโปรโมชั่น
  Future<void> _loadUserAndData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // สมมติว่าตอน Login คุณเก็บ ID ไว้ในชื่อ 'user_id'
      // ถ้าคุณใช้ชื่ออื่น (เช่น 'id', 'uid') ให้เปลี่ยนให้ตรงกันนะครับ
      currentUserId = prefs.getString('user_id'); 
    });
    fetchPromotions();
  }

  Future<void> fetchPromotions() async {
    try {
      final response = await http.get(Uri.parse("http://10.0.2.2/my_shop/get_promotions.php"));
      if (response.statusCode == 200) {
        setState(() {
          promotions = json.decode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> claimVoucher(String promoId) async {
    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("กรุณาเข้าสู่ระบบก่อนเก็บโค้ด")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2/my_shop/claim_promotion.php"),
        body: {
          "user_id": currentUserId!, 
          "promotion_id": promoId
        },
      );

      final result = json.decode(response.body);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
        if (result['status'] == 'success') {
          fetchPromotions(); // อัปเดตจำนวนคงเหลือหน้าจอ
        }
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("โปรโมชั่น"),
        backgroundColor: const Color.fromARGB(255, 209, 0, 0),
        foregroundColor: Colors.white,
      ),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator(color: Colors.red))
        : ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: promotions.length,
            itemBuilder: (context, index) {
              final item = promotions[index];
              int remaining = item['limit'] - item['claimed'];

              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      const Icon(Icons.confirmation_number, color: Colors.red, size: 50),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['code'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            Text(item['discount_type'] == 'percentage' 
                                ? "ลด ${item['discount_value']}%" 
                                : "ลด ${item['discount_value']} บาท"),
                            Text("สิทธิ์คงเหลือ: $remaining", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: remaining > 0 ? () => claimVoucher(item['id']) : null,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                        child: Text(remaining > 0 ? "เก็บโค้ด" : "เต็มแล้ว"),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }
}
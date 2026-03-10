import 'package:flutter/material.dart';

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    // รับค่ายอดรวม (ใช้ double ตามที่เราส่งจาก BuyNow)
    final double netAmount = ModalRoute.of(context)!.settings.arguments as double? ?? 0.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 100),
              ),
              const SizedBox(height: 24),
              const Text(
                "สั่งซื้อสินค้าสำเร็จ!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "ขอบคุณที่ใช้บริการครับ\nยอดชำระทั้งหมดของคุณคือ",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                "฿${netAmount.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFFC70000)),
              ),
              const SizedBox(height: 40),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // กลับไปหน้าแรกสุด (หน้า Home) ทันที โดยไม่ไปหน้า Logo
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC70000),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("ตกลง", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String? userId;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('user_id') ?? prefs.getInt('user_id')?.toString();
    if (userId != null) {
      await http.post(
        Uri.parse("http://10.0.2.2/my_shop/mark_as_read.php"),
        body: {"user_id": userId},
      );
      setState(() {});
    }
  }

  Future<List> _fetch() async {
    if (userId == null) return [];
    final res = await http.get(
      Uri.parse(
        "http://10.0.2.2/my_shop/get_notifications.php?user_id=$userId",
      ),
    );
    return res.statusCode == 200 ? json.decode(res.body) : [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification', style: GoogleFonts.outfit()),
        centerTitle: true,
      ),
      body: FutureBuilder<List>(
        future: _fetch(),
        builder: (context, snap) {
          if (!snap.hasData)
            return const Center(child: CircularProgressIndicator());
          if (snap.data!.isEmpty)
            return const Center(child: Text("ไม่มีการแจ้งเตือน"));
          return ListView.separated(
            padding: const EdgeInsets.all(10),
            itemCount: snap.data!.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final item = snap.data![index];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.notifications)),
                title: Text(
                  _msg(item['status']),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "ออเดอร์ #${item['id']} เมื่อ ${item['created_at']}",
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _msg(String s) {
    if (s == 'pending') return 'สั่งซื้อสำเร็จ! รอร้านค้าตรวจสอบ';
    if (s == 'paid') return 'รับยอดชำระแล้ว กำลังเตรียมส่ง';
    if (s == 'shipped') return 'สินค้าถูกส่งออกมาแล้ว!';
    if (s == 'completed') return 'จัดส่งสำเร็จ!';
    if (s == 'cancelled') return 'ออเดอร์ถูกยกเลิกแล้ว';
    return 'มีการอัปเดตสถานะ';
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderHistoryPage extends StatefulWidget {
  final String userId;
  final String initialStatus; 

  const OrderHistoryPage({
    super.key,
    required this.userId,
    this.initialStatus = 'all',
  });

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    
    // 1. คำนวณหา Index (ต้องสัมพันธ์กับจำนวน Tab ด้านล่าง)
    int initialIndex = 0; // 'all'
    if (widget.initialStatus == 'pending') initialIndex = 1;
    if (widget.initialStatus == 'paid') initialIndex = 2;
    if (widget.initialStatus == 'shipped') initialIndex = 3;
    if (widget.initialStatus == 'completed') initialIndex = 4; // หน้าที่ 5

    // 2. กำหนด length เป็น 5 ให้ตรงกับจำนวน Tab ทั้งหมด
    _tabController = TabController(
      length: 5, 
      vsync: this, 
      initialIndex: initialIndex,
    );
  }

  Future<List> _fetchOrders(String status) async {
    try {
      final response = await http.get(
        Uri.parse(
          "http://10.0.2.2/my_shop/get_user_orders.php?user_id=${widget.userId}&status=$status",
        ),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return [];
    } catch (e) {
      debugPrint("Error: $e");
      return [];
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("คำสั่งซื้อของฉัน"),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          // รายการปุ่ม Tab (ต้องมี 5 ปุ่ม)
          tabs: const [
            Tab(text: "ทั้งหมด"),
            Tab(text: "ที่ต้องชำระ"),
            Tab(text: "ที่ต้องจัดส่ง"),
            Tab(text: "ที่ต้องได้รับ"),
            Tab(text: "ที่ต้องให้คะแนน"), // เพิ่ม Tab นี้
          ],
        ),
      ),
      // รายการหน้าเนื้อหา (ต้องมี 5 หน้า และลำดับต้องตรงกับ Tab)
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderList('all'),       // Index 0
          _buildOrderList('pending'),   // Index 1
          _buildOrderList('paid'),      // Index 2
          _buildOrderList('shipped'),   // Index 3
          _buildOrderList('completed'), // Index 4 (ตรงกับ initialStatus 'completed')
        ],
      ),
    );
  }

  Widget _buildOrderList(String status) {
    return FutureBuilder<List>(
      future: _fetchOrders(status),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("ไม่มีรายการคำสั่งซื้อ"));
        }

        final orders = snapshot.data!;
        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: Column(
                children: [
                  ListTile(
                    title: Text("ออเดอร์ #${order['id']}"),
                    subtitle: Text("สถานะ: ${order['status']}"),
                    trailing: Text(
                      "฿${order['net_amount']}",
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (order['items'] != null && (order['items'] as List).isNotEmpty)
                    ListTile(
                      leading: Image.network(
                        "http://10.0.2.2/my_shop/images/${order['items'][0]['image_url']}",
                        width: 50,
                        errorBuilder: (context, error, stackTrace) => 
                          const Icon(Icons.image_not_supported),
                      ),
                      title: Text(order['items'][0]['name']),
                      subtitle: Text("x${order['items'][0]['quantity']}"),
                    ),
                  if (order['tracking_number'] != null)
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.grey[100],
                      child: Row(
                        children: [
                          const Icon(Icons.local_shipping, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            "เลขติดตาม: ${order['tracking_number']} (${order['carrier_name']})",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
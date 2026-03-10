import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'product_model.dart';
import 'api_service.dart';

class BuyNowPage extends StatefulWidget {
  const BuyNowPage({super.key});

  @override
  State<BuyNowPage> createState() => _BuyNowPageState();
}

class _BuyNowPageState extends State<BuyNowPage> {
  String userAddress = "กำลังโหลด...";
  String userName = "กำลังโหลด...";
  String userPhone = "08x-xxx-xxxx";
  String? currentUserId;

  List<Map<String, dynamic>> checkoutItems = [];
  double subtotal = 0;
  double discountAmount = 0; // ส่วนลดสินค้า
  double shippingDiscountAmount = 0; // ส่วนลดค่าส่ง
  double shippingFee = 40.0; // สมมติค่าส่งพื้นฐาน 40 บาท
  double totalPrice = 0;

  Map<String, dynamic>? selectedVoucher; // เก็บโค้ดส่วนลดสินค้า
  Map<String, dynamic>? selectedFreeShipping; // เก็บโค้ดส่งฟรี

  bool _isInitialized = false;
  bool _isFromCart = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId =
          prefs.getString('user_id') ?? prefs.getInt('user_id')?.toString();
      userName = prefs.getString('username') ?? "ไม่ระบุชื่อ";
      userAddress = prefs.getString('address') ?? "ยังไม่มีที่อยู่";
      userPhone = prefs.getString('phone') ?? "08x-xxx-xxxx";
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      if (args.containsKey('items')) {
        checkoutItems = List<Map<String, dynamic>>.from(args['items']);
        _isFromCart = true;
      } else if (args.containsKey('product')) {
        checkoutItems = [
          {
            'product': args['product'] as Product,
            'quantity': args['quantity'] as int,
          },
        ];
        _isFromCart = false;
      }
      _calculateTotal();
      _isInitialized = true;
    }
  }

  void _calculateTotal() {
    // 1. คำนวณราคาสินค้าทั้งหมด
    double currentSubtotal = checkoutItems.fold(0, (sum, item) {
      final Product p = item['product'];
      final int q = item['quantity'];
      return sum + (double.parse(p.price) * q);
    });

    // 2. คำนวณส่วนลดสินค้า (Voucher)
    double discount = 0;
    if (selectedVoucher != null) {
      double val = double.parse(selectedVoucher!['discount_value'].toString());
      if (selectedVoucher!['discount_type'] == 'percentage') {
        discount = currentSubtotal * (val / 100);
      } else {
        discount = val;
      }
    }

    // 3. คำนวณส่วนลดค่าส่ง (Free Shipping)
    double shipDisc = 0;
    if (selectedFreeShipping != null) {
      shipDisc = double.parse(
        selectedFreeShipping!['discount_value'].toString(),
      );
      // ถ้าส่วนลดค่าส่งมากกว่าค่าส่งจริง ให้ลดได้สูงสุดแค่เท่าค่าส่ง
      if (shipDisc > shippingFee) shipDisc = shippingFee;
    }

    setState(() {
      subtotal = currentSubtotal;
      discountAmount = discount;
      shippingDiscountAmount = shipDisc;
      // ยอดสุทธิ = (ราคาสินค้า - ส่วนลดสินค้า) + (ค่าส่ง - ส่วนลดค่าส่ง)
      totalPrice = (currentSubtotal - discount) + (shippingFee - shipDisc);
    });
  }

  // ฟังก์ชันเลือกโค้ด (ใช้ร่วมกันทั้ง 2 ประเภทโดยการกรอง filter)
  void _showVoucherPicker(String filterType) async {
    if (currentUserId == null) return;
    try {
      final response = await http.get(
        Uri.parse(
          "http://10.0.2.2/my_shop/get_user_vouchers.php?user_id=$currentUserId",
        ),
      );

      List allVouchers = json.decode(response.body);
      // กรองเอาเฉพาะประเภทที่ต้องการ
      List filtered = allVouchers
          .where((v) => v['promotion_type'] == filterType)
          .toList();

      if (!mounted) return;

      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                filterType == 'free_shipping'
                    ? "เลือกโค้ดส่งฟรี"
                    : "เลือกส่วนลดของคุณ",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              if (filtered.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text("ไม่มีโค้ดให้เลือก"),
                )
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final v = filtered[index];
                      return ListTile(
                        leading: Icon(
                          filterType == 'free_shipping'
                              ? Icons.local_shipping
                              : Icons.confirmation_number,
                          color: filterType == 'free_shipping'
                              ? Colors.green
                              : Colors.red,
                        ),
                        title: Text(v['code']),
                        subtitle: Text(
                          filterType == 'free_shipping'
                              ? "ส่วนลดค่าจัดส่ง ฿${v['discount_value']}"
                              : (v['discount_type'] == 'percentage'
                                    ? "ลด ${v['discount_value']}%"
                                    : "ลด ฿${v['discount_value']}"),
                        ),
                        onTap: () {
                          setState(() {
                            if (filterType == 'free_shipping') {
                              selectedFreeShipping = v;
                            } else {
                              selectedVoucher = v;
                            }
                            _calculateTotal();
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      );
    } catch (e) {
      debugPrint("Voucher Error: $e");
    }
  }

  // ... (ฟังก์ชัน _clearPurchasedItemsFromCart เหมือนเดิม) ...

  Future<void> _placeOrder() async {
    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("กรุณาเข้าสู่ระบบก่อนสั่งซื้อ")),
      );
      return;
    }

    // รวม ID โค้ดที่จะใช้ (ส่งไป PHP)
    // หมายเหตุ: ถ้า place_order.php ของคุณรับโค้ดเดียว คุณต้องเลือกส่ง แต่อันนี้ผมรวมให้ดูเผื่อคุณปรับ DB ให้เก็บ 2 โค้ดได้
    List<String> usedVoucherIds = [];
    if (selectedVoucher != null) usedVoucherIds.add(selectedVoucher!['id']);
    if (selectedFreeShipping != null)
      usedVoucherIds.add(selectedFreeShipping!['id']);

    // ... (ส่วนการเช็คสต็อกเหมือนเดิมของคุณ) ...

    try {
      Map<String, dynamic> orderData = {
        "user_id": currentUserId,
        "promotion_id": selectedVoucher != null
            ? selectedVoucher!['id']
            : null, // ส่ง ID ส่วนลดหลัก
        "shipping_promotion_id": selectedFreeShipping != null
            ? selectedFreeShipping!['id']
            : null, // ส่ง ID ส่งฟรี (ถ้ามี)
        "total_price": subtotal,
        "discount_amount": discountAmount + shippingDiscountAmount,
        "net_amount": totalPrice,
        "items": checkoutItems.map((item) {
          final Product p = item['product'];
          return {
            "product_id": p.id,
            "quantity": item['quantity'],
            "price": p.price,
          };
        }).toList(),
      };

      // ... (ส่วนการยิง http.post เหมือนเดิมของคุณ) ...
      final response = await http.post(
        Uri.parse("http://10.0.2.2/my_shop/place_order.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(orderData),
      );

      if (!mounted) return;
      final result = jsonDecode(response.body);
      if (result['status'] == 'success') {
        Navigator.pushReplacementNamed(
          context,
          '/order_success',
          arguments: totalPrice,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("ไม่สามารถสั่งซื้อได้: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("ทำการสั่งซื้อ")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildAddressSection(),
            const Divider(thickness: 8, color: Color(0xFFF5F5F5)),
            _buildProductList(),
            const Divider(thickness: 8, color: Color(0xFFF5F5F5)),

            // --- โค้ดส่วนลดสินค้า ---
            ListTile(
              leading: const Icon(Icons.local_offer, color: Colors.red),
              title: Text(
                selectedVoucher == null
                    ? "เลือกโค้ดส่วนลด"
                    : "ส่วนลด: ${selectedVoucher!['code']}",
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _showVoucherPicker('discount'),
            ),
            const Divider(),

            // --- โค้ดส่งฟรี ---
            ListTile(
              leading: const Icon(Icons.local_shipping, color: Colors.green),
              title: Text(
                selectedFreeShipping == null
                    ? "เลือกโค้ดส่งฟรี"
                    : "ส่งฟรี: ${selectedFreeShipping!['code']}",
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _showVoucherPicker('free_shipping'),
            ),

            const Divider(thickness: 8, color: Color(0xFFF5F5F5)),
            _buildPaymentSummary(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // ปรับการโชว์ยอดเงินให้ชัดเจนขึ้น
  Widget _buildPaymentSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _rowSummary("ยอดรวมสินค้า", "฿${subtotal.toStringAsFixed(2)}"),
          _rowSummary("ค่าจัดส่ง", "฿${shippingFee.toStringAsFixed(2)}"),
          if (discountAmount > 0)
            _rowSummary(
              "ส่วนลดสินค้า",
              "-฿${discountAmount.toStringAsFixed(2)}",
              color: Colors.red,
            ),
          if (shippingDiscountAmount > 0)
            _rowSummary(
              "ส่วนลดค่าจัดส่ง",
              "-฿${shippingDiscountAmount.toStringAsFixed(2)}",
              color: Colors.green,
            ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "ยอดสุทธิ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                "฿${totalPrice.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _rowSummary(String title, String value, {Color color = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(value, style: TextStyle(color: color)),
        ],
      ),
    );
  }
  // --- ส่วนของ Widget ที่ใช้โชว์ที่อยู่ ---
  Widget _buildAddressSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.location_on, color: Colors.red),
              SizedBox(width: 8),
              Text("ที่อยู่จัดส่ง", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32, top: 8),
            child: Text("$userName | $userPhone\n$userAddress"),
          ),
        ],
      ),
    );
  }

  // --- ส่วนของ Widget ที่ใช้โชว์รายการสินค้า ---
  Widget _buildProductList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: checkoutItems.length,
      itemBuilder: (context, index) {
        final product = checkoutItems[index]['product'];
        final int quantity = checkoutItems[index]['quantity'];
        return ListTile(
          leading: Image.network("http://10.0.2.2/my_shop/images/${product.imageUrl}", width: 50, errorBuilder: (c, e, s) => const Icon(Icons.image)),
          title: Text(product.name),
          subtitle: Text("฿${product.price} x $quantity"),
          trailing: Text("฿${(double.parse(product.price) * quantity).toStringAsFixed(2)}"),
        );
      },
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: _placeOrder,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red, minimumSize: const Size(double.infinity, 50)),
        child: const Text("สั่งซื้อสินค้า", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}



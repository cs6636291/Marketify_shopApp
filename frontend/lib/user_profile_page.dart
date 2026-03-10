import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketify_app/core/common/constants/app_constants.dart';
import 'package:marketify_app/features/auth/presentation/page/auth_signin_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'order_history_page.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String userId = "";
  String userName = "Loading...";
  String userEmail = "Loading...";
  String userAddress = "Loading...";
  String userJoined = "Loading...";
  String userPhone = "Loading...";

  // ตัวแปรสำหรับเก็บจำนวน Badge
  int countToPay = 0;
  int countToShip = 0;
  int countToReceive = 0;
  int countToRate = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // ฟังก์ชันดึงจำนวนออเดอร์จาก PHP ที่คุณสร้างไว้
  Future<void> _fetchOrderCounts() async {
    if (userId.isEmpty) return;
    try {
      final response = await http.get(
        Uri.parse(
          "http://10.0.2.2/my_shop/get_order_counts.php?user_id=$userId",
        ),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          countToPay = data['to_pay'] ?? 0;
          countToShip = data['to_ship'] ?? 0;
          countToReceive = data['to_receive'] ?? 0;
          countToRate = data['to_rate'] ?? 0;
        });
      }
    } catch (e) {
      debugPrint("Error fetching counts: $e");
    }
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id') ?? "";
      userEmail = prefs.getString('user_email') ?? "No Email";

      String? name = prefs.getString('username');
      userName = (name == null || name.isEmpty || name == "null")
          ? "ยังไม่ได้ตั้งชื่อ"
          : name;

      String? addr = prefs.getString('address');
      userAddress = (addr == null || addr.isEmpty || addr == "null")
          ? "ยังไม่ได้กรอกที่อยู่"
          : addr;
      String? phone = prefs.getString('phone');
      userPhone = (phone == null || phone.isEmpty || phone == "null")
          ? "ยังไม่ได้ระบุเบอร์โทร"
          : phone;

      userJoined = prefs.getString('created_at') ?? "ไม่ระบุวันที่";
    });

    // เมื่อโหลด User ข้อมูลเสร็จ ให้ไปดึงเลข Badge ต่อทันที
    if (userId.isNotEmpty) {
      _fetchOrderCounts();
    }
  }

  void _navigateToOrders(String status) {
    if (userId.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            OrderHistoryPage(userId: userId, initialStatus: status),
      ),
    ).then((value) {
      // เมื่อกลับมาจากหน้าออเดอร์ ให้โหลดเลข Badge ใหม่เผื่อมีการเปลี่ยนแปลง
      _fetchOrderCounts();
    });
  }

  Future<void> _updateProfileInDatabase(String key, String newValue) async {
    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2/my_shop/update_profile.php"),
        body: {
          "user_id": userId,
          "username": key == "username" ? newValue : userName,
          "address": key == "address" ? newValue : userAddress,
          "phone": key == "phone" ? newValue : userPhone,
        },
      );

      final data = json.decode(response.body);

      if (data['status'] == "success") {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(key, newValue);
        _loadUserData();
      }
    } catch (e) {
      debugPrint("Error updating database: $e");
    }
  }

  Future<void> _showEditDialog(
    String title,
    String key,
    String currentValue,
  ) async {
    String initialText =
        (currentValue == "ยังไม่ได้ตั้งชื่อ" ||
            currentValue == "ยังไม่ได้กรอกที่อยู่" ||
            currentValue == "ยังไม่ได้ระบุเบอร์โทร" ||
            currentValue == "Loading...")
        ? ""
        : currentValue;

    TextEditingController editController = TextEditingController(
      text: initialText,
    );

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "แก้ไข $title",
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: editController,
            decoration: InputDecoration(
              hintText: "กรอก$titleของคุณ",
              border: const OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("ยกเลิก"),
            ),
            ElevatedButton(
              onPressed: () async {
                String newValue = editController.text.trim();
                await _updateProfileInDatabase(key, newValue);
                if (!mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("บันทึก $title เรียบร้อยแล้ว"),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text("บันทึก"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onLogoutPressed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const AuthSigninPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: AppConstants.primaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text("Profile", style: GoogleFonts.outfit(color: Colors.white)),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/cart'),
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchOrderCounts, // ดึงลงเพื่อรีเฟรชเลข Badge ได้
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 25),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        'https://s.isanook.com/ns/0/ud/232/1162528/news01-1.jpg',
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            userEmail,
                            style: GoogleFonts.outfit(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          _showEditDialog("ชื่อผู้ใช้", "username", userName),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text("Edit"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _sectionCard(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () =>
                          _showEditDialog("ที่อยู่", "address", userAddress),
                      child: _infoTile(
                        Icons.location_on_outlined,
                        "ที่อยู่",
                        userAddress,
                      ),
                    ),
                    const Divider(),
                    InkWell(
                      onTap: () =>
                          _showEditDialog("เบอร์โทรศัพท์", "phone", userPhone),
                      child: _infoTile(
                        Icons.phone_android_outlined,
                        "เบอร์โทรศัพท์",
                        userPhone,
                      ),
                    ),
                    const Divider(),
                    _infoTile(
                      Icons.calendar_month_outlined,
                      "เป็นสมาชิกเมื่อ",
                      userJoined,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              _sectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "My Purchases",
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _orderItem(
                          Icons.account_balance_wallet_outlined,
                          "To Pay",
                          countToPay, // ใช้ตัวแปรจริง
                          () => _navigateToOrders('pending'),
                        ),
                        _orderItem(
                          Icons.shopify_outlined,
                          "To Ship",
                          countToShip, // ใช้ตัวแปรจริง
                          () => _navigateToOrders('paid'),
                        ),
                        _orderItem(
                          Icons.local_shipping_outlined,
                          "To Receive",
                          countToReceive, // ใช้ตัวแปรจริง
                          () => _navigateToOrders('shipped'),
                        ),
                        _orderItem(
                          Icons.stars_outlined,
                          "To Rate",
                          countToRate, // ใช้ตัวแปรจริง
                          () => _navigateToOrders('completed'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              _sectionCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Logout"),
                        content: const Text("Are you sure?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: _onLogoutPressed,
                            child: const Text(
                              "Logout",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppConstants.primaryColor, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  value,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (title == "ที่อยู่" || title == "เบอร์โทรศัพท์")
            const Icon(Icons.edit, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _orderItem(
    IconData icon,
    String title,
    int badgeCount,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none, // เพื่อให้ Badge ล้นออกมาได้สวยๆ
              children: [
                Icon(icon, size: 35),
                if (badgeCount > 0)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        badgeCount > 99 ? '99+' : badgeCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(title, style: GoogleFonts.outfit(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
        ],
      ),
      child: child,
    );
  }
}

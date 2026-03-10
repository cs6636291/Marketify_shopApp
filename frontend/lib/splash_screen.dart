import 'package:flutter/material.dart';
import 'package:marketify_app/core/common/constants/app_constants.dart';
import 'package:marketify_app/features/auth/presentation/page/auth_signin_page.dart';
import 'package:marketify_app/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // เพิ่ม import

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideUpAnimation;
  late Animation<double> _scaleUpAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _fadeInAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _slideUpAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutSine));

    _scaleUpAnimation = Tween<double>(
      begin: 0.96,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    // เริ่มกระบวนการเช็คสถานะการเข้าสู่ระบบ
    _checkAuthAndNavigate();
  }

  // ฟังก์ชันใหม่สำหรับเช็ค SharedPreferences
  Future<void> _checkAuthAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    // ลองหาค่า user_id ถ้าไม่มีจะเป็น null
    final String? userId = prefs.getString('user_id');

    // รอให้ Animation โชว์อย่างน้อย 3 วินาทีตามใจเจ้าของโค้ด
    await Future.delayed(const Duration(milliseconds: 3000));

    if (mounted) {
      Widget nextScreen;

      // ถ้า userId ไม่เป็น null แปลว่าเคย Login แล้ว
      if (userId != null && userId.isNotEmpty) {
        nextScreen = const MainScreen();
      } else {
        nextScreen = const AuthSigninPage();
      }

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 1000),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  // ส่วน build เหมือนเดิมทุกประการ...
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(221, 49, 49, 49),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return FadeTransition(
              opacity: _fadeInAnimation,
              child: SlideTransition(
                position: _slideUpAnimation,
                child: ScaleTransition(
                  scale: _scaleUpAnimation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 200,
                        height: 200,
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppConstants.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
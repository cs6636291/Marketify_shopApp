import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketify_app/core/common/constants/app_constants.dart';
import 'package:marketify_app/features/auth/presentation/page/auth_signup_page.dart';
import 'package:marketify_app/features/auth/presentation/page/forgot_password_screen.dart';
import 'package:marketify_app/features/auth/presentation/widgets/auth_widgets.dart';
import 'package:marketify_app/main_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthSigninPage extends StatefulWidget {
  const AuthSigninPage({super.key});

  @override
  State<AuthSigninPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthSigninPage> {
  final _signInForkey = GlobalKey<FormState>();
  final _signInEmailController = TextEditingController();
  final _signInPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _signInEmailController.dispose();
    _signInPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onSignInPressed() async {
    if (_signInForkey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await http.post(
          Uri.parse("http://10.0.2.2/my_shop/login.php"),
          body: {
            "email": _signInEmailController.text.trim(),
            "password": _signInPasswordController.text,
          },
        );

        final data = json.decode(response.body);

        if (data['status'] == "success") {
          final prefs = await SharedPreferences.getInstance();
          
          var user = data['user'];

          await prefs.setString('user_id', user['id'].toString());
          await prefs.setString('user_email', user['email']);
          await prefs.setString('username', user['username']?.toString() ?? '');
          await prefs.setString('address', user['address']?.toString() ?? '');
          await prefs.setString('created_at', user['created_at']?.toString() ?? '');

          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("เข้าสู่ระบบสำเร็จ"),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message']),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (!mounted) return;
        debugPrint("DEBUG_ERROR: $e");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 5),
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _signInForkey,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 180,
                      height: 180,
                    ),
                  ),
                  const SizedBox(height: 40),
                  AuthTextField(
                    controller: _signInEmailController,
                    label: 'Email',
                    hint: 'Enter your Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email ";
                      }
                      if (!value.contains('@')) {
                        return "Please enter a valid email ";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  AuthTextField(
                    controller: _signInPasswordController,
                    label: 'Password',
                    hint: 'Enter your Password',
                    keyboardType: TextInputType.visiblePassword,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your Password ";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: GoogleFonts.outfit(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  AuthButton(
                    text: 'Sign In',
                    onPressed: _onSignInPressed,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: GoogleFonts.outfit(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AuthSignupPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.outfit(
                            color: AppConstants.primaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
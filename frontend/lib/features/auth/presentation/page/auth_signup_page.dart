import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketify_app/core/common/constants/app_constants.dart';
import 'package:marketify_app/features/auth/presentation/widgets/auth_widgets.dart';
import 'package:marketify_app/main_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthSignupPage extends StatefulWidget {
  const AuthSignupPage({super.key});

  @override
  State<AuthSignupPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthSignupPage> {
  final _signUpForkey = GlobalKey<FormState>();
  final _signUpNameController = TextEditingController();
  final _signUpEmailController = TextEditingController();
  final _signUpPasswordController = TextEditingController();
  final _signUpConfirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _signUpNameController.dispose();
    _signUpEmailController.dispose();
    _signUpPasswordController.dispose();
    _signUpConfirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onSignUpPressed() async {
    if (_signUpForkey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await http.post(
          Uri.parse("http://10.0.2.2/my_shop/register.php"),
          body: {
            "email": _signUpEmailController.text.trim(),
            "password": _signUpPasswordController.text,
          },
        );

        final data = json.decode(response.body);

        if (data['status'] == "success") {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message']),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้")),
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
      appBar: AppBar(backgroundColor: Colors.white),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _signUpForkey,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Your Account',
                    style: GoogleFonts.outfit(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 35),
                  AuthTextField(
                    controller: _signUpEmailController,
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
                    controller: _signUpPasswordController,
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
                  const SizedBox(height: 20),
                  AuthTextField(
                    controller: _signUpConfirmPasswordController,
                    label: 'Confirm Password',
                    hint: 'Confirm your Password',
                    keyboardType: TextInputType.visiblePassword,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your Password ";
                      }
                      if (value != _signUpPasswordController.text) {
                        return "Password do not match";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 60),
                  AuthButton(
                    text: 'Create Account',
                    onPressed: _onSignUpPressed,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

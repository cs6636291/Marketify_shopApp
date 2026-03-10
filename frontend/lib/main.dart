import 'package:flutter/material.dart';
import 'package:marketify_app/buyNow_page.dart';
import 'package:marketify_app/cart_page.dart';
import 'package:marketify_app/category_page.dart';
import 'package:marketify_app/notification_page.dart';
import 'package:marketify_app/order_success_page.dart';
import 'package:marketify_app/product_detail_page.dart';
import 'package:marketify_app/shop_profile_page.dart';
import 'package:marketify_app/splash_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'product_model.dart';
import 'product_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: SplashScreen(),
      routes: {
        '/noti': (context) => const NotificationPage(),
        '/cart': (context) => const CartPage(),
        '/productdetail': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Product;
          return ProductDetailPage(product: args);
        },
        '/shopprofile': (context) => const ShopProfileScreen(),
        '/buynow': (context) => BuyNowPage(),
        '/order_success': (context) => const OrderSuccessPage(),
      },
    );
  }
}

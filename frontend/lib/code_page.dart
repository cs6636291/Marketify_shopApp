import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketify_app/core/common/constants/app_constants.dart';

class CodeCoupon extends StatefulWidget {
  const CodeCoupon({super.key});

  @override
  State<CodeCoupon> createState() => _CodeCouponState();
}

class _CodeCouponState extends State<CodeCoupon>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Coupons & Deals',
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_bag_outlined),
            color: Colors.black,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppConstants.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppConstants.primaryColor,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Free Shipping'),
            Tab(text: 'App Discount'),
            Tab(text: 'Store Voucher'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          FreeShippingTab(),
          AppDiscountTab(),
          StoreVoucherTab(),
        ],
      ),
    );
  }
}

class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160,
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        image: const DecorationImage(
          image: NetworkImage(
            'https://marketplace.canva.com/EAGvt7arfJE/1/0/1600w/canva-red-yellow-and-blue-modern-fashion-sale-medium-banner-CMxDpY2Tnrc.jpg',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class FreeShippingTab extends StatelessWidget {
  const FreeShippingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        BannerWidget(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomVoucherCard(
                  title: 'Free Shipping',
                  subtitle: 'Min. Spend ฿0',
                  tag: 'All Products',
                  color: Colors.green,
                  icon: Icons.local_shipping,
                ),
                CustomVoucherCard(
                  title: 'Free Shipping',
                  subtitle: 'Min. Spend ฿500',
                  tag: 'Flash Deal',
                  color: Colors.green,
                  icon: Icons.local_shipping,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AppDiscountTab extends StatelessWidget {
  const AppDiscountTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        BannerWidget(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomVoucherCard(
                  title: '5% off Up to ฿3,000',
                  subtitle: 'Min. Spend ฿5,000',
                  tag: 'Specific Gold Product',
                  color: Colors.amber,
                  icon: Icons.percent,
                ),
                CustomVoucherCard(
                  title: '10% off Up to ฿1,000',
                  subtitle: 'Min. Spend ฿2,000',
                  tag: 'Hot Deal',
                  color: Colors.amber,
                  icon: Icons.percent,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class StoreVoucherTab extends StatelessWidget {
  const StoreVoucherTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BannerWidget(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomVoucherCard(
                  title: 'Store Discount ฿100',
                  subtitle: 'Min. Spend ฿1,000',
                  tag: 'Official Store Only',
                  color: AppConstants.primaryColor,
                  icon: Icons.store,
                ),
                CustomVoucherCard(
                  title: 'Store Cashback 5%',
                  subtitle: 'Min. Spend ฿800',
                  tag: 'Today Only',
                  color: AppConstants.primaryColor,
                  icon: Icons.store,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CustomVoucherCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String tag;
  final Color color;
  final IconData icon;

  const CustomVoucherCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.color,
    required this.icon,
  });

  @override
  State<CustomVoucherCard> createState() => _CustomVoucherCardState();
}

class _CustomVoucherCardState extends State<CustomVoucherCard> {
  bool claimed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 85,
            height: 110,
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(14),
              ),
            ),
            child: Icon(widget.icon, color: Colors.white, size: 32),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(widget.subtitle, style: GoogleFonts.outfit()),
                  const SizedBox(height: 6),
                  Text(
                    widget.tag,
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      color: widget.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: claimed ? Colors.grey : widget.color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                setState(() => claimed = true);
              },
              child: Text(
                claimed ? 'Claimed' : 'Claim',
                style: GoogleFonts.outfit(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

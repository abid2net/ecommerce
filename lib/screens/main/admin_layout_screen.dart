import 'package:flutter/material.dart';
import 'package:ecommerce/screens/product/product_management_screen.dart';
import 'package:ecommerce/screens/profile/profile_screen.dart';
import 'package:ecommerce/screens/order_management_screen.dart';
import 'package:ecommerce/screens/review_management_screen.dart';

class AdminLayoutScreen extends StatefulWidget {
  const AdminLayoutScreen({super.key});

  @override
  State<AdminLayoutScreen> createState() => _AdminLayoutScreenState();
}

class _AdminLayoutScreenState extends State<AdminLayoutScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Admin Panel')),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ProductListView(),
          OrderManagementScreen(),
          ReviewManagementScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(icon: Icon(Icons.inventory), text: 'Products'),
          Tab(icon: Icon(Icons.list), text: 'Orders'),
          Tab(icon: Icon(Icons.rate_review), text: 'Reviews'),
          Tab(icon: Icon(Icons.person), text: 'Profile'),
        ],
      ),
    );
  }
}

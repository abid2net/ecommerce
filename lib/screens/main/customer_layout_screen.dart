import 'package:ecommerce/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/screens/home/home_screen.dart';
import 'package:ecommerce/screens/profile/profile_screen.dart';
import 'package:ecommerce/screens/cart/cart_screen.dart';
import 'package:ecommerce/screens/order/order_screen.dart';
import 'package:ecommerce/blocs/cart/cart_bloc.dart';

class CustomerLayoutScreen extends StatefulWidget {
  const CustomerLayoutScreen({super.key});

  @override
  State<CustomerLayoutScreen> createState() => _CustomerLayoutScreenState();
}

class _CustomerLayoutScreenState extends State<CustomerLayoutScreen>
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
      body: TabBarView(
        controller: _tabController,
        children: const [
          HomeScreen(),
          CartScreen(),
          OrderScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          final itemCount = state.products.fold<int>(
            0,
            (sum, product) => sum + (product.quantity ?? 1),
          );

          return TabBar(
            controller: _tabController,
            tabs: [
              const Tab(icon: Icon(Icons.home), text: 'Home'),
              Tab(
                icon: Badge(
                  backgroundColor: AppTheme.quaternaryColor,
                  isLabelVisible: itemCount > 0,
                  label: Text(itemCount.toString()),
                  child: const Icon(Icons.shopping_cart),
                ),
                text: 'Cart',
              ),
              const Tab(icon: Icon(Icons.history), text: 'Orders'),
              const Tab(icon: Icon(Icons.person), text: 'Profile'),
            ],
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ecommerce/screens/home/home_screen.dart';
import 'package:ecommerce/screens/profile/profile_screen.dart';

class CustomerLayoutScreen extends StatefulWidget {
  const CustomerLayoutScreen({super.key});

  @override
  State<CustomerLayoutScreen> createState() => _CustomerLayoutScreenState();
}

class _CustomerLayoutScreenState extends State<CustomerLayoutScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [const HomeScreen(), const ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

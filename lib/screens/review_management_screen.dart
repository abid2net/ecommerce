import 'package:flutter/material.dart';

class ReviewManagementScreen extends StatelessWidget {
  const ReviewManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reviews')),
      body: const Center(child: Text('Review Management Screen')),
    );
  }
}

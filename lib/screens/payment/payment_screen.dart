import 'package:ecommerce/models/order_model.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/blocs/cart/cart_bloc.dart';
import 'package:ecommerce/repositories/order_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentScreen extends StatelessWidget {
  final double total;
  final List<ProductModel> products;

  const PaymentScreen({super.key, required this.total, required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Summary',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Total Amount: \$${total.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'Items: ${products.length}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _confirmPayment(context),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Confirm Payment'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmPayment(BuildContext context) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      final orderRepository = OrderRepository();
      final orderId = DateTime.now().millisecondsSinceEpoch.toString();

      final order = OrderModel(
        id: orderId,
        userId: userId,
        products: products,
        total: total,
        status: OrderStatus.pending,
        createdAt: DateTime.now(),
      );

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Create order in Firestore
      await orderRepository.createOrder(order);

      // Clear cart
      if (context.mounted) {
        context.read<CartBloc>().add(ClearCart());
      }

      // Close loading dialog and payment screen
      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
        Navigator.pop(context); // Close payment screen

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order placed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

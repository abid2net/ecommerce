import 'package:ecommerce/common/common.dart';
import 'package:ecommerce/models/order_model.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:ecommerce/screens/address_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/blocs/cart/cart_bloc.dart';
import 'package:ecommerce/repositories/order_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce/models/discount_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/address_model.dart';

class PaymentScreen extends StatefulWidget {
  final double total;
  final List<ProductModel> products;

  const PaymentScreen({super.key, required this.total, required this.products});

  @override
  State createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _discountController = TextEditingController();
  DiscountModel? _appliedDiscount;
  bool _isValidating = false;
  AddressModel? _selectedAddress;

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  double get _discountedTotal {
    if (_appliedDiscount == null) return widget.total;
    return widget.total * (1 - _appliedDiscount!.percentage / 100);
  }

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal:'),
                        Text('\$${widget.total.toStringAsFixed(2)}'),
                      ],
                    ),
                    if (_appliedDiscount != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Discount (${_appliedDiscount!.percentage}%):'),
                          Text(
                            '-\$${(widget.total - _discountedTotal).toStringAsFixed(2)}',
                          ),
                        ],
                      ),
                    ],
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '\$${_discountedTotal.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Discount Code',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _discountController,
                            decoration: const InputDecoration(
                              hintText: 'Enter code',
                              border: OutlineInputBorder(),
                            ),
                            enabled: _appliedDiscount == null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _isValidating
                            ? const CircularProgressIndicator()
                            : TextButton(
                              onPressed:
                                  _appliedDiscount == null
                                      ? _validateDiscount
                                      : _removeDiscount,
                              child: Text(
                                _appliedDiscount == null ? 'Apply' : 'Remove',
                              ),
                            ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Select Address',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final address = await Navigator.push<AddressModel>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddressSelectionScreen(),
                  ),
                );
                if (address != null) {
                  setState(() {
                    _selectedAddress = address;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _selectedAddress != null
                      ? '${_selectedAddress!.name}, ${_selectedAddress!.street}, ${_selectedAddress!.city}, ${_selectedAddress!.state}, ${_selectedAddress!.zipCode}, ${_selectedAddress!.country}'
                      : 'Tap to select or add an address',
                  style: TextStyle(
                    color:
                        _selectedAddress != null ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                if (_selectedAddress == null) {
                  showErrorSnackBar(
                    context: context,
                    message: 'Please select an address',
                  );
                  return;
                }
                _confirmPayment(context);
              },
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

  Future<void> _validateDiscount() async {
    final code = _discountController.text.trim();
    if (code.isEmpty) return;

    setState(() => _isValidating = true);

    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('discounts')
              .where('code', isEqualTo: code)
              .where('isActive', isEqualTo: true)
              .get();

      if (snapshot.docs.isNotEmpty) {
        final discount = DiscountModel.fromMap(snapshot.docs.first.data());

        // Check if discount is expired
        if (discount.expiryDate != null &&
            discount.expiryDate!.isBefore(DateTime.now()) &&
            mounted) {
          showErrorSnackBar(
            context: context,
            message: 'This discount code has expired',
          );
          return;
        }

        // Check if discount is valid for products in cart
        if (!discount.isValidForProducts(widget.products)) {
          if (mounted) {
            showErrorSnackBar(
              context: context,
              message:
                  'This discount code is not valid for the selected products',
            );
          }
          return;
        }

        setState(() => _appliedDiscount = discount);
        if (mounted) {
          showSuccessSnackBar(
            context: context,
            message: 'Discount applied successfully!',
          );
        }
      } else {
        if (mounted) {
          showErrorSnackBar(context: context, message: 'Invalid discount code');
        }
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(
          context: context,
          message: 'Error validating discount code',
        );
      }
    } finally {
      setState(() => _isValidating = false);
    }
  }

  void _removeDiscount() {
    setState(() => _appliedDiscount = null);
    _discountController.clear();
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
        products: widget.products,
        total: _discountedTotal,
        discountCode: _appliedDiscount?.code,
        discountPercentage: _appliedDiscount?.percentage,
        status: OrderStatus.pending,
        createdAt: DateTime.now(),
        shippingAddress: _selectedAddress,
      );

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      await orderRepository.createOrder(order);

      if (context.mounted) {
        context.read<CartBloc>().add(ClearCart());
        Navigator.pop(context); // Close loading dialog
        Navigator.pop(context); // Close payment screen
        showSuccessSnackBar(
          context: context,
          message: 'Order placed successfully!',
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        showErrorSnackBar(context: context, message: 'Error: ${e.toString()}');
      }
    }
  }
}

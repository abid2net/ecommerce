import 'package:ecommerce/common/common.dart';
import 'package:ecommerce/common/widgets/custom_loading.dart';
import 'package:ecommerce/models/order_model.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:ecommerce/screens/address_selection_screen.dart';
import 'package:ecommerce/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/blocs/cart/cart_bloc.dart';
import 'package:ecommerce/repositories/order_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce/models/voucher_model.dart';
import 'package:ecommerce/models/address_model.dart';
import 'package:ecommerce/repositories/voucher_repository.dart';

class PaymentScreen extends StatefulWidget {
  final double total;
  final List<ProductModel> products;

  const PaymentScreen({super.key, required this.total, required this.products});

  @override
  State createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _discountController = TextEditingController();
  VoucherModel? _appliedDiscount;
  bool _isValidating = false;
  AddressModel? _selectedAddress;

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  double get _discountedTotal {
    if (_appliedDiscount == null) return widget.total;

    // Calculate the total discount for valid products
    double discountAmount = 0.0;

    for (var product in widget.products) {
      if (_appliedDiscount!.validCategories.isNotEmpty) {
        if (_appliedDiscount!.validCategories.contains(product.category.id)) {
          discountAmount +=
              product.price * (_appliedDiscount!.percentage / 100);
        }
      } else {
        discountAmount += product.price * (_appliedDiscount!.percentage / 100);
      }
    }

    return widget.total -
        discountAmount; // Subtract the total discount from the original total
  }

  bool _isValidDiscountForProduct(ProductModel product) {
    if (_appliedDiscount != null &&
        _appliedDiscount!.validCategories.isNotEmpty) {
      return _appliedDiscount!.validCategories.contains(product.category.id);
    } else {
      return _appliedDiscount != null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Product List
              Text('Products', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.products.length,
                itemBuilder: (context, index) {
                  final product = widget.products[index];
                  double discountedPrice = product.price;

                  // Check if discount is applicable
                  if (_isValidDiscountForProduct(product)) {
                    discountedPrice =
                        product.price *
                        (1 - _appliedDiscount!.percentage / 100);
                  }

                  return ListTile(
                    title: Text(product.name),
                    subtitle: Row(
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child:
                              product.images.isNotEmpty
                                  ? Image.network(
                                    product.images.first,
                                    fit: BoxFit.cover,
                                  )
                                  : const Icon(Icons.image),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price: \$${product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                decoration:
                                    _isValidDiscountForProduct(product)
                                        ? TextDecoration.lineThrough
                                        : null,
                              ),
                            ),
                            if (_isValidDiscountForProduct(product))
                              Text(
                                'Discounted Price: \$${discountedPrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: AppTheme.secondaryColor,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              // Subtotal and Discount
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
                            Text(
                              'Discount (${_appliedDiscount!.percentage}%):',
                            ),
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
                          const Text('Total:'),
                          Text('\$${_discountedTotal.toStringAsFixed(2)}'),
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
                              ? const CustomLoadingIndicator()
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
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed:
                    _selectedAddress == null
                        ? null
                        : () {
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
      ),
    );
  }

  Future<void> _validateDiscount() async {
    final code = _discountController.text.trim();
    if (code.isEmpty) return;

    setState(() => _isValidating = true);

    try {
      final voucherRepository = VoucherRepository();
      final discount = await voucherRepository.validateDiscount(code);

      if (discount == null && mounted) {
        showErrorSnackBar(
          context: context,
          message: 'Invalid or expired discount code',
        );
        return;
      }

      // Check if discount is valid for products in cart
      if (discount != null &&
          !discount.isValidForProducts(widget.products) &&
          mounted) {
        showErrorSnackBar(
          context: context,
          message: 'This discount code is not valid for the selected products',
        );
        return;
      }

      setState(() => _appliedDiscount = discount);
      if (mounted) {
        showSuccessSnackBar(
          context: context,
          message: 'Discount applied successfully!',
        );
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(
          context: context,
          message: 'Error validating discount: ${e.toString()}',
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
        builder: (context) => const CustomLoadingIndicator(),
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

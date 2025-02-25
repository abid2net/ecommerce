import 'package:ecommerce/screens/payment/payment_screen.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:ecommerce/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/blocs/wishlist/wishlist_bloc.dart';
import 'package:ecommerce/blocs/cart/cart_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        actions: [
          BlocBuilder<WishlistBloc, WishlistState>(
            builder: (context, state) {
              final isInWishlist = state.isInWishlist(widget.product.id);
              return IconButton(
                icon: Icon(
                  isInWishlist ? Icons.favorite : Icons.favorite_border,
                  color: isInWishlist ? Colors.red : null,
                ),
                onPressed: () {
                  if (isInWishlist) {
                    context.read<WishlistBloc>().add(
                      RemoveFromWishlist(widget.product.id),
                    );
                  } else {
                    context.read<WishlistBloc>().add(
                      AddToWishlist(widget.product),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.product.images.isNotEmpty)
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CarouselSlider.builder(
                    itemCount: widget.product.images.length,
                    options: CarouselOptions(
                      height: 300,
                      viewportFraction: 1.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentImageIndex = index;
                        });
                      },
                    ),
                    itemBuilder: (context, index, realIndex) {
                      return Image.network(
                        widget.product.images[index],
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox(
                            height: 300,
                            child: Center(child: Icon(Icons.error)),
                          );
                        },
                      );
                    },
                  ),
                  if (widget.product.images.length > 1)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DotsIndicator(
                        dotsCount: widget.product.images.length,
                        position: _currentImageIndex.toDouble(),
                        decorator: DotsDecorator(
                          color: Colors.grey.withValues(alpha: 0.5),
                          activeColor: Theme.of(context).primaryColor,
                          size: const Size(8.0, 8.0),
                          activeSize: const Size(8.0, 8.0),
                        ),
                      ),
                    ),
                ],
              )
            else
              const SizedBox(
                height: 300,
                child: Center(child: Icon(Icons.image, size: 100)),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$${widget.product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Category: ${widget.product.category.displayName}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description ?? 'No description available',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),

                  Center(
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed:
                            () => _showQuantityDialog(context, isBuyNow: false),
                        child: const Text('Add to Cart'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed:
                            () => _showQuantityDialog(context, isBuyNow: true),
                        child: const Text('Buy now'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showQuantityDialog(
    BuildContext context, {
    bool isBuyNow = false,
  }) async {
    int quantity = 1;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Select Quantity'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed:
                        quantity > 1 ? () => setState(() => quantity--) : null,
                  ),
                  Text(
                    quantity.toString(),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => setState(() => quantity++),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text('Add'),
                  onPressed: () {
                    if (isBuyNow) {
                      double total = widget.product.price * quantity;
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => PaymentScreen(
                                total: total,
                                products: [
                                  ProductModel(
                                    id: widget.product.id,
                                    name: widget.product.name,
                                    price: widget.product.price,
                                    images: widget.product.images,
                                    description: widget.product.description,
                                    category: widget.product.category,
                                    quantity: quantity,
                                  ),
                                ],
                              ),
                        ),
                      );
                    } else {
                      context.read<CartBloc>().add(
                        AddToCart(widget.product, quantity: quantity),
                      );
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

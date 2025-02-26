import 'package:ecommerce/screens/payment/payment_screen.dart';
import 'package:ecommerce/theme/app_theme.dart';
import 'package:ecommerce/widgets/rating_bar.dart';
import 'package:ecommerce/widgets/review_dialog.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/blocs/wishlist/wishlist_bloc.dart';
import 'package:ecommerce/blocs/cart/cart_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:ecommerce/widgets/review_card.dart';
import 'package:ecommerce/blocs/review/review_bloc.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load reviews when screen is initialized
    context.read<ReviewBloc>().add(LoadReviews(widget.product.id));
  }

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
                  color: isInWishlist ? AppTheme.quaternaryColor : null,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${widget.product.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          RatingBar(rating: widget.product.rating, size: 20),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.product.rating.toStringAsFixed(1)} (${widget.product.reviewCount} reviews)',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Brand: ${widget.product.brand}',
                    style: Theme.of(context).textTheme.bodyMedium,
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
                  const SizedBox(height: 25),

                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1.3,
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
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.tertiaryColor,
                        ),
                        onPressed:
                            () => _showQuantityDialog(context, isBuyNow: true),
                        child: const Text('Buy now'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Reviews Section
                  Text(
                    'Customer Reviews',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  // Add Review Button
                  Center(
                    child: OutlinedButton.icon(
                      onPressed: () => _showReviewDialog(context),
                      icon: const Icon(Icons.rate_review),
                      label: const Text('Write a Review'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<ReviewBloc, ReviewState>(
                    builder: (context, state) {
                      if (state is ReviewLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is ReviewError) {
                        return Center(child: Text('Error: ${state.message}'));
                      }

                      if (state is ReviewLoaded) {
                        final reviews = state.reviews;

                        if (reviews.isEmpty) {
                          return const Center(child: Text('No reviews yet'));
                        }

                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: reviews.length,
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) {
                            final review = reviews[index];
                            return ReviewCard(review: review);
                          },
                        );
                      }

                      return const SizedBox();
                    },
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
                                    brand: widget.product.brand,
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

  Future<void> _showReviewDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => ReviewDialog(productId: widget.product.id),
    );
  }
}

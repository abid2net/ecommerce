import 'package:ecommerce/screens/home/product_search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/blocs/product/product_bloc.dart';
import 'package:ecommerce/models/category_model.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:ecommerce/screens/product/product_details_screen.dart';
import 'package:ecommerce/screens/wishlist/wishlist_screen.dart';
import 'package:ecommerce/widgets/rating_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String _searchQuery = '';
  ProductCategory? _selectedCategory;
  RangeValues _priceRange = const RangeValues(0, 0);
  RangeValues _originlPriceRange = const RangeValues(0, 0);

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadProducts());
  }

  void _updatePriceRange(List<ProductModel> products) {
    if (products.isEmpty) return;

    final maxPrice = products
        .map((p) => p.price)
        .reduce((a, b) => a > b ? a : b);
    setState(() {
      _priceRange = RangeValues(0, maxPrice);
      _originlPriceRange = RangeValues(0, maxPrice);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: ProductSearchDelegate());
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WishlistScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: BlocConsumer<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state is ProductLoaded && _priceRange.end == 0) {
                  _updatePriceRange(state.products);
                }
              },
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ProductLoaded) {
                  final filteredProducts = _filterProducts(state.products);
                  return CustomScrollView(
                    slivers: [
                      // _buildCategoryList(),
                      SliverPadding(
                        padding: const EdgeInsets.all(8.0),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                mainAxisSpacing: 8.0,
                                crossAxisSpacing: 8.0,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final product = filteredProducts[index];
                            return _buildProductCard(product);
                          }, childCount: filteredProducts.length),
                        ),
                      ),
                    ],
                  );
                }

                return const Center(child: Text('No products found'));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<ProductCategory>(
              value: _selectedCategory,
              hint: const Text('All Categories'),
              isExpanded: true,
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('All Categories'),
                ),
                ...ProductCategory.values.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category.displayName),
                  );
                }),
              ],
              onChanged: (value) => setState(() => _selectedCategory = value),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showPriceFilter,
          ),
        ],
      ),
    );
  }

  // Widget _buildCategoryList() {
  //   return SliverToBoxAdapter(
  //     child: SizedBox(
  //       height: 120,
  //       child: ListView.builder(
  //         scrollDirection: Axis.horizontal,
  //         padding: const EdgeInsets.all(8.0),
  //         itemCount: ProductCategory.values.length,
  //         itemBuilder: (context, index) {
  //           final category = ProductCategory.values[index];
  //           final isSelected = category == _selectedCategory;

  //           return Card(
  //             color:
  //                 isSelected
  //                     ? Theme.of(context).colorScheme.primaryContainer
  //                     : null,
  //             child: InkWell(
  //               onTap: () => setState(() => _selectedCategory = category),
  //               child: Container(
  //                 width: 100,
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Icon(
  //                       category.categoryIcon,
  //                       size: 32,
  //                       color:
  //                           isSelected
  //                               ? Theme.of(context).colorScheme.primary
  //                               : null,
  //                     ),
  //                     const SizedBox(height: 8),
  //                     Text(
  //                       category.displayName,
  //                       textAlign: TextAlign.center,
  //                       style: Theme.of(context).textTheme.bodySmall?.copyWith(
  //                         color:
  //                             isSelected
  //                                 ? Theme.of(context).colorScheme.primary
  //                                 : null,
  //                         fontWeight: isSelected ? FontWeight.bold : null,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }

  Widget _buildProductCard(ProductModel product) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(product: product),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child:
                  product.images.isNotEmpty
                      ? Image.network(
                        product.images.first,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )
                      : const Icon(Icons.image, size: 100),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      RatingBar(rating: product.rating, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '(${product.reviewCount})',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
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

  List<ProductModel> _filterProducts(List<ProductModel> products) {
    return products.where((product) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          product.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == null || product.category == _selectedCategory;
      final matchesPrice =
          product.price >= _priceRange.start &&
          product.price <= _priceRange.end;
      return matchesSearch && matchesCategory && matchesPrice;
    }).toList();
  }

  void _showPriceFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Price Range: \$${_priceRange.start.toInt()} - \$${_priceRange.end.toInt()}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: _originlPriceRange.end.toDouble(),
                    divisions: 20,
                    labels: RangeLabels(
                      '\$${_priceRange.start.toInt()}',
                      '\$${_priceRange.end.toInt()}',
                    ),
                    onChanged: (values) {
                      setState(() => _priceRange = values);
                      this.setState(() {});
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

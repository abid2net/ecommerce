import 'package:ecommerce/common/widgets/custom_loading.dart';
import 'package:ecommerce/screens/product/product_details_screen.dart';
import 'package:ecommerce/screens/voucher/voucher_management_screen.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:ecommerce/widgets/product/product_list_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/blocs/product/product_bloc.dart';
import 'package:ecommerce/screens/profile/profile_screen.dart';

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  State<ProductManagementScreen> createState() =>
      _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const ProductListView(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Products',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class ProductListView extends StatefulWidget {
  const ProductListView({super.key});

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'manageCategories') {
                Navigator.pushNamed(context, '/categories');
              } else if (value == 'manageVouchers') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VoucherManagementScreen(),
                  ),
                );
              }
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'manageCategories',
                    child: Text('Manage Categories'),
                  ),
                  const PopupMenuItem(
                    value: 'manageVouchers',
                    child: Text('Manage Vouchers'),
                  ),
                ],
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToProductForm(context),
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const CustomLoadingIndicator();
          }

          if (state is ProductLoaded) {
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return ProductListItem(
                  product: product,
                  onEdit:
                      () => Navigator.pushNamed(
                        context,
                        '/products/edit',
                        arguments: product,
                      ),
                  onDelete: () => _showDeleteDialog(context, product),
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  ProductDetailsScreen(product: product),
                        ),
                      ),
                );
              },
            );
          }

          if (state is ProductError) {
            return Center(child: Text(state.message));
          }

          return const Center(child: Text('No products found'));
        },
      ),
    );
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    ProductModel product,
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: Text('Are you sure you want to delete ${product.name}?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                context.read<ProductBloc>().add(DeleteProduct(product.id));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToProductForm(BuildContext context) {
    Navigator.pushNamed(context, '/products/add');
  }
}

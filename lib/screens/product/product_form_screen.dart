import 'package:flutter/material.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:ecommerce/blocs/product/product_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/models/category_model.dart';
import 'package:ecommerce/blocs/category/category_bloc.dart';

class ProductFormScreen extends StatefulWidget {
  final bool isEditing;
  final ProductModel? product;

  const ProductFormScreen({super.key, this.isEditing = false, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  final List<TextEditingController> _imageUrlControllers = [];
  CategoryModel? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name);
    _descriptionController = TextEditingController(
      text: widget.product?.description,
    );
    _priceController = TextEditingController(
      text: widget.product?.price.toString(),
    );

    if (widget.product?.images.isNotEmpty == true) {
      for (var imageUrl in widget.product!.images) {
        _imageUrlControllers.add(TextEditingController(text: imageUrl));
      }
    } else {
      _imageUrlControllers.add(TextEditingController());
    }

    context.read<CategoryBloc>().add(LoadCategories());
  }

  void _addImageField() {
    setState(() {
      _imageUrlControllers.add(TextEditingController());
    });
  }

  void _removeImageField(int index) {
    setState(() {
      _imageUrlControllers[index].dispose();
      _imageUrlControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Product' : 'Add Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator:
                      (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator:
                      (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 24),
                const Text('Product Images'),
                const SizedBox(height: 8),
                // Image URL fields
                ...List.generate(_imageUrlControllers.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextFormField(
                      controller: _imageUrlControllers[index],
                      decoration: InputDecoration(
                        labelText: 'Image URL ${index + 1}',
                        suffixIcon:
                            index > 0
                                ? IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () => _removeImageField(index),
                                )
                                : null,
                      ),
                    ),
                  );
                }),
                if (_imageUrlControllers.length < 10)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                    child: ElevatedButton.icon(
                      onPressed: _addImageField,
                      icon: const Icon(Icons.add_photo_alternate),
                      label: const Text('Add Another Image URL'),
                    ),
                  ),
                const SizedBox(height: 16),
                _buildCategoryDropdown(),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(widget.isEditing ? 'Update' : 'Add'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoaded) {
          if (!mounted) return const CircularProgressIndicator();

          // Create default tyre category
          final defaultCategory = CategoryModel(
            id: 'tyres',
            name: 'tyres',
            displayName: 'Tyres',
            icon: Icons.tire_repair,
          );

          // Initialize selected category
          if (_selectedCategory == null) {
            if (widget.product != null) {
              _selectedCategory = widget.product!.category;
            } else if (state.categories.isNotEmpty) {
              // Try to find tyres category or use first available
              _selectedCategory = state.categories.firstWhere(
                (cat) => cat.name.toLowerCase() == 'tyres',
                orElse: () => state.categories.first,
              );
            } else {
              // If no categories exist, use default
              _selectedCategory = defaultCategory;
            }
          }

          // Get available categories
          final categories =
              state.categories.isEmpty ? [defaultCategory] : state.categories;

          // Ensure selected category is in the list
          if (!categories.any((cat) => cat.id == _selectedCategory!.id)) {
            _selectedCategory = categories.first;
          }

          return DropdownButtonFormField<CategoryModel>(
            value: _selectedCategory,
            decoration: const InputDecoration(labelText: 'Category'),
            items:
                categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category.displayName),
                  );
                }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedCategory = value);
              }
            },
            validator: (value) => value == null ? 'Required' : null,
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final product = ProductModel(
      id:
          widget.isEditing
              ? widget.product!.id
              : DateTime.now().microsecondsSinceEpoch.toString(),
      name: _nameController.text,
      description: _descriptionController.text,
      price: double.parse(_priceController.text),
      images:
          _imageUrlControllers
              .map((controller) => controller.text)
              .where((url) => url.isNotEmpty)
              .toList(),
      category: _selectedCategory!,
    );

    if (widget.isEditing) {
      context.read<ProductBloc>().add(UpdateProduct(product));
    } else {
      context.read<ProductBloc>().add(AddProduct(product));
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    for (var controller in _imageUrlControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}

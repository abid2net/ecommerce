import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/blocs/category/category_bloc.dart';
import 'package:ecommerce/models/category_model.dart';
import 'package:ecommerce/repositories/category_repository.dart';

class CategoryManagementScreen extends StatelessWidget {
  const CategoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCategoryDialog(context),
          ),
        ],
      ),
      body: BlocConsumer<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state is CategoryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CategoryLoaded) {
            if (state.categories.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('No categories found'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<CategoryRepository>()
                            .seedInitialCategories();
                        context.read<CategoryBloc>().add(LoadCategories());
                      },
                      child: const Text('Add Initial Categories'),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final category = state.categories[index];
                return ListTile(
                  leading: Icon(category.icon),
                  title: Text(category.displayName),
                  subtitle: Text(category.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed:
                            () => _showCategoryDialog(
                              context,
                              category: category,
                            ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _showDeleteDialog(context, category),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          return const Center(child: Text('No categories found'));
        },
      ),
    );
  }

  Future<void> _showCategoryDialog(
    BuildContext context, {
    CategoryModel? category,
  }) {
    return showDialog(
      context: context,
      builder: (context) => CategoryFormDialog(category: category),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, CategoryModel category) {
    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Category'),
            content: Text(
              'Are you sure you want to delete "${category.displayName}"?',
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('Delete'),
                onPressed: () {
                  context.read<CategoryBloc>().add(DeleteCategory(category.id));
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
    );
  }
}

class CategoryFormDialog extends StatefulWidget {
  final CategoryModel? category;

  const CategoryFormDialog({super.key, this.category});

  @override
  State<CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<CategoryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _displayNameController;
  IconData _selectedIcon = Icons.category;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name);
    _displayNameController = TextEditingController(
      text: widget.category?.displayName,
    );
    if (widget.category != null) {
      _selectedIcon = widget.category!.icon;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.category == null ? 'Add Category' : 'Edit Category'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name (ID)'),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _displayNameController,
              decoration: const InputDecoration(labelText: 'Display Name'),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<IconData>(
              value: _selectedIcon,
              decoration: const InputDecoration(labelText: 'Icon'),
              items:
                  _getCommonIcons().map((IconData icon) {
                    return DropdownMenuItem(
                      value: icon,
                      child: Row(
                        children: [
                          Icon(icon),
                          const SizedBox(width: 8),
                          Text(icon.toString()),
                        ],
                      ),
                    );
                  }).toList(),
              onChanged: (IconData? value) {
                if (value != null) {
                  setState(() => _selectedIcon = value);
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          onPressed: _submitForm,
          child: Text(widget.category == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final category = CategoryModel(
      id:
          widget.category?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      displayName: _displayNameController.text.trim(),
      icon: _selectedIcon,
    );

    if (widget.category == null) {
      context.read<CategoryBloc>().add(AddCategory(category));
    } else {
      context.read<CategoryBloc>().add(UpdateCategory(category));
    }

    Navigator.of(context).pop();
  }

  List<IconData> _getCommonIcons() {
    return [
      Icons.category,
      Icons.devices,
      Icons.checkroom,
      Icons.book,
      Icons.restaurant,
      Icons.directions_car,
      Icons.chair,
      Icons.tire_repair,
      Icons.toys,
      Icons.handyman,
      Icons.sports,
      Icons.music_note,
      Icons.pets,
      Icons.home,
      Icons.shopping_bag,
    ];
  }
}

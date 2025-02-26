import 'package:flutter/material.dart';
import 'package:ecommerce/models/product_model.dart';

class ProductListItem extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductListItem({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: _buildProductImage(),
        title: Text(product.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.brand.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Text(product.brand),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text('\$${product.price.toStringAsFixed(2)}'),
            ),
            Text(
              product.description ?? '',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    if (product.images.isEmpty) {
      return const Icon(Icons.image, size: 50);
    }

    return Image.network(
      product.images.first,
      width: 50,
      height: 50,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.error, size: 50);
      },
    );
  }
}

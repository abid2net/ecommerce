part of 'wishlist_bloc.dart';

class WishlistState {
  final List<ProductModel> products;

  WishlistState(this.products);

  bool isInWishlist(String productId) {
    return products.any((product) => product.id == productId);
  }
}

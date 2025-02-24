part of 'wishlist_bloc.dart';

abstract class WishlistEvent {}

class AddToWishlist extends WishlistEvent {
  final ProductModel product;
  AddToWishlist(this.product);
}

class RemoveFromWishlist extends WishlistEvent {
  final String productId;
  RemoveFromWishlist(this.productId);
}

class LoadWishlist extends WishlistEvent {}

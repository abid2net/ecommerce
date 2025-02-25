part of 'cart_bloc.dart';

abstract class CartEvent {}

class AddToCart extends CartEvent {
  final ProductModel product;
  final int quantity;
  AddToCart(this.product, {this.quantity = 1});
}

class BuyNow extends CartEvent {
  final ProductModel product;
  final int quantity;
  BuyNow(this.product, {this.quantity = 1});
}

class LoadCart extends CartEvent {}

class RemoveFromCart extends CartEvent {
  final String productId;
  RemoveFromCart(this.productId);
}

class ClearCart extends CartEvent {}

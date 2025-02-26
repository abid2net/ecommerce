part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddToCart extends CartEvent {
  final ProductModel product;
  final int quantity;
  const AddToCart(this.product, {this.quantity = 1});

  @override
  List<Object> get props => [product, quantity];
}

class BuyNow extends CartEvent {
  final ProductModel product;
  final int quantity;
  const BuyNow(this.product, {this.quantity = 1});

  @override
  List<Object> get props => [product, quantity];
}

class LoadCart extends CartEvent {}

class RemoveFromCart extends CartEvent {
  final String productId;
  const RemoveFromCart(this.productId);

  @override
  List<Object> get props => [productId];
}

class ClearCart extends CartEvent {}

class UpdateCartItemQuantity extends CartEvent {
  final String productId;
  final int quantity;

  const UpdateCartItemQuantity(this.productId, this.quantity);

  @override
  List<Object> get props => [productId, quantity];
}

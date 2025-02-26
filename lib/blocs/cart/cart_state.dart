part of 'cart_bloc.dart';

class CartState {
  final List<ProductModel> products;
  CartState(this.products);

  double get total => products.fold<double>(
    0,
    (sumValue, product) => sumValue + (product.price * (product.quantity ?? 1)),
  );
}

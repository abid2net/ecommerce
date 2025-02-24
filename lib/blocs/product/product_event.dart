part of 'product_bloc.dart';

abstract class ProductEvent {}

class AddProduct extends ProductEvent {
  final ProductModel product;
  AddProduct(this.product);
}

class UpdateProduct extends ProductEvent {
  final ProductModel product;
  UpdateProduct(this.product);
}

class LoadProducts extends ProductEvent {}

class DeleteProduct extends ProductEvent {
  final String id;
  DeleteProduct(this.id);
}

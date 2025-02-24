import 'package:ecommerce/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/repositories/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;

  ProductBloc({required ProductRepository productRepository})
    : _productRepository = productRepository,
      super(ProductInitial()) {
    on<AddProduct>(_onAddProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
    on<LoadProducts>(_onLoadProducts);
  }

  Future<void> _onAddProduct(
    AddProduct event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ProductLoading());
      await _productRepository.addProduct(event.product);
      emit(ProductSuccess('Product added successfully'));
      add(LoadProducts());
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onUpdateProduct(
    UpdateProduct event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ProductLoading());
      await _productRepository.updateProduct(event.product);
      emit(ProductSuccess('Product updated successfully'));
      add(LoadProducts());
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onDeleteProduct(
    DeleteProduct event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ProductLoading());
      await _productRepository.deleteProduct(event.id);
      emit(ProductSuccess('Product deleted successfully'));
      add(LoadProducts()); // Reload the products list
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ProductLoading());
      final productsStream = _productRepository.getProducts();
      await emit.forEach(
        productsStream,
        onData: (List<ProductModel> products) {
          print('Loaded ${products.length} products'); // Debug print
          return ProductLoaded(products);
        },
        onError: (error, stackTrace) => ProductError(error.toString()),
      );
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}

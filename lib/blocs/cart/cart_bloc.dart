import 'package:ecommerce/common/common.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:ecommerce/repositories/cart_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CartBloc({required CartRepository cartRepository})
    : _cartRepository = cartRepository,
      super(CartState([])) {
    on<AddToCart>(_onAddToCart);
    on<BuyNow>(_onBuyNow);
    on<LoadCart>(_onLoadCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<ClearCart>(_onClearCart);

    add(LoadCart()); // Load cart when bloc is created
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    await _cartRepository.addToCart(event.product, quantity: event.quantity);
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    await _cartRepository.removeFromCart(event.productId);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    await emit.forEach(
      _cartRepository.getCart(),
      onData: (List<ProductModel> products) => CartState(products),
    );
  }

  Future<void> _onBuyNow(BuyNow event, Emitter<CartState> emit) async {
    await _cartRepository.addToCart(event.product, quantity: event.quantity);
    // TODO: Implement checkout logic
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    // Delete all cart items
    final cartRef = _firestore
        .collection(FirebaseConstants.users)
        .doc(userId)
        .collection(FirebaseConstants.cart);

    final cartDocs = await cartRef.get();
    for (var doc in cartDocs.docs) {
      await doc.reference.delete();
    }
  }
}

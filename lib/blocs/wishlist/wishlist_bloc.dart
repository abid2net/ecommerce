import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:ecommerce/repositories/wishlist_repository.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final WishlistRepository _wishlistRepository;

  WishlistBloc({required WishlistRepository wishlistRepository})
    : _wishlistRepository = wishlistRepository,
      super(WishlistState([])) {
    on<AddToWishlist>(_onAddToWishlist);
    on<RemoveFromWishlist>(_onRemoveFromWishlist);
    on<LoadWishlist>(_onLoadWishlist);

    add(LoadWishlist()); // Load wishlist when bloc is created
  }

  Future<void> _onAddToWishlist(
    AddToWishlist event,
    Emitter<WishlistState> emit,
  ) async {
    await _wishlistRepository.addToWishlist(event.product);
  }

  Future<void> _onRemoveFromWishlist(
    RemoveFromWishlist event,
    Emitter<WishlistState> emit,
  ) async {
    await _wishlistRepository.removeFromWishlist(event.productId);
  }

  Future<void> _onLoadWishlist(
    LoadWishlist event,
    Emitter<WishlistState> emit,
  ) async {
    await emit.forEach(
      _wishlistRepository.getWishlist(),
      onData: (List<ProductModel> products) => WishlistState(products),
    );
  }
}

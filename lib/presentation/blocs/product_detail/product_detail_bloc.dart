import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bazaar/presentation/blocs/product_detail/product_detail_event.dart';
import 'package:bazaar/presentation/blocs/product_detail/product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  ProductDetailBloc() : super(ProductDetailInitial()) {
    on<AddToCart>(_onAddToCart);
    on<AddToWishlist>(_onAddToWishlist);
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<ProductDetailState> emit) async {
    emit(ProductDetailLoading());
    try {
      // Placeholder: Simulate adding to cart
      await Future.delayed(const Duration(seconds: 1));
      emit(const ProductDetailSuccess('Added to Cart'));
    } catch (e) {
      emit(ProductDetailError(e.toString()));
    }
  }

  Future<void> _onAddToWishlist(AddToWishlist event, Emitter<ProductDetailState> emit) async {
    emit(ProductDetailLoading());
    try {
      // Placeholder: Simulate adding to wishlist
      await Future.delayed(const Duration(seconds: 1));
      emit(const ProductDetailSuccess('Added to Wishlist'));
    } catch (e) {
      emit(ProductDetailError(e.toString()));
    }
  }
}
import 'package:bazaar/data/models/product_model.dart';
import 'package:bazaar/data/repositories/wishlist_repository_impl.dart';
import 'package:bazaar/domain/usecases/add_to_wishlist.dart';
import 'package:bazaar/presentation/blocs/cart/cart_bloc.dart';
import 'package:bazaar/presentation/blocs/cart/cart_event.dart' as CartEvents;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bazaar/presentation/blocs/product_detail/product_detail_event.dart' as DetailEvents;
import 'package:bazaar/presentation/blocs/product_detail/product_detail_state.dart';

class ProductDetailBloc extends Bloc<DetailEvents.ProductDetailEvent, ProductDetailState> {
  ProductDetailBloc() : super(ProductDetailInitial()) {
    on<DetailEvents.AddToCart>(_onAddToCart);
    on<DetailEvents.AddToWishlist>(_onAddToWishlist);
  }

  Future<void> _onAddToCart(DetailEvents.AddToCart event, Emitter<ProductDetailState> emit) async {
    emit(ProductDetailLoading());
    try {
      final cartBloc = BlocProvider.of<CartBloc>(event.context);
      cartBloc.add(CartEvents.AddToCart(event.product));
      emit(const ProductDetailSuccess('Added to Cart'));
    } catch (e) {
      emit(ProductDetailError(e.toString()));
    }
  }

  Future<void> _onAddToWishlist(DetailEvents.AddToWishlist event, Emitter<ProductDetailState> emit) async {
    emit(ProductDetailLoading());
    try {
      await AddToWishlist(WishlistRepositoryImpl()).call(event.product);
      emit(const ProductDetailSuccess('Added to Wishlist'));
    } catch (e) {
      emit(ProductDetailError(e.toString()));
    }
  }
}
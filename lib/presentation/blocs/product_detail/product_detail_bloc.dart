import 'package:bazaar/data/models/product_model.dart';
import 'package:bazaar/domain/usecases/add_to_wishlist.dart';
import 'package:bazaar/domain/usecases/get_wishlist.dart';
import 'package:bazaar/domain/usecases/remove_from_wishlist.dart';
import 'package:bazaar/presentation/blocs/cart/cart_bloc.dart';
import 'package:bazaar/presentation/blocs/cart/cart_event.dart' as CartEvents;
import 'package:bazaar/presentation/blocs/wishlist/wishlist_bloc.dart';
import 'package:bazaar/presentation/blocs/wishlist/wishlist_event.dart' as WishlistEvents;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bazaar/presentation/blocs/product_detail/product_detail_event.dart' as DetailEvents;
import 'package:bazaar/presentation/blocs/product_detail/product_detail_state.dart';

class ProductDetailBloc extends Bloc<DetailEvents.ProductDetailEvent, ProductDetailState> {
  final AddToWishlist addToWishlist;
  final RemoveFromWishlist removeFromWishlist;
  final GetWishlist getWishlist;

  ProductDetailBloc({
    required this.addToWishlist,
    required this.removeFromWishlist,
    required this.getWishlist,
  }) : super(ProductDetailInitial()) {
    on<DetailEvents.AddToCart>(_onAddToCart);
    on<DetailEvents.ToggleWishlist>(_onToggleWishlist);
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

  Future<void> _onToggleWishlist(DetailEvents.ToggleWishlist event, Emitter<ProductDetailState> emit) async {
    emit(ProductDetailLoading());
    try {
      final wishlistBloc = BlocProvider.of<WishlistBloc>(event.context);
      final wishlist = await getWishlist();
      final isInWishlist = wishlist.items.any((item) => item.product.id == event.product.id);
      if (isInWishlist) {
        await removeFromWishlist(event.product.id);
        wishlistBloc.add(WishlistEvents.RemoveFromWishlist(event.product.id));
      } else {
        await addToWishlist(event.product);
        wishlistBloc.add(WishlistEvents.AddToWishlist(event.product));
      }
      emit(ProductDetailInitial());
    } catch (e) {
      emit(ProductDetailError('Failed to toggle wishlist: ${e.toString()}'));
    }
  }
}
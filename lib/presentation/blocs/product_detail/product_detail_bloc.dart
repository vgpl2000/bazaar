import 'package:bazaar/domain/usecases/add_to_wishlist.dart';
import 'package:bazaar/domain/usecases/get_wishlist.dart';
import 'package:bazaar/domain/usecases/remove_from_wishlist.dart';
import 'package:bazaar/presentation/blocs/cart/cart_bloc.dart';
import 'package:bazaar/presentation/blocs/cart/cart_event.dart' as cart_events;
import 'package:bazaar/presentation/blocs/wishlist/wishlist_bloc.dart';
import 'package:bazaar/presentation/blocs/wishlist/wishlist_event.dart' as wishlist_events;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bazaar/presentation/blocs/product_detail/product_detail_event.dart' as detail_events;
import 'package:bazaar/presentation/blocs/product_detail/product_detail_state.dart';

class ProductDetailBloc extends Bloc<detail_events.ProductDetailEvent, ProductDetailState> {
  final AddToWishlist addToWishlist;
  final RemoveFromWishlist removeFromWishlist;
  final GetWishlist getWishlist;

  ProductDetailBloc({
    required this.addToWishlist,
    required this.removeFromWishlist,
    required this.getWishlist,
  }) : super(ProductDetailInitial()) {
    on<detail_events.AddToCart>(_onAddToCart);
    on<detail_events.ToggleWishlist>(_onToggleWishlist);
  }

  Future<void> _onAddToCart(detail_events.AddToCart event, Emitter<ProductDetailState> emit) async {
    emit(ProductDetailLoading());
    try {
      final cartBloc = BlocProvider.of<CartBloc>(event.context);
      cartBloc.add(cart_events.AddToCart(event.product));
      emit(const ProductDetailSuccess('Product added to Cart. Happy Shopping!'));
    } catch (e) {
      emit(ProductDetailError(e.toString()));
    }
  }

  Future<void> _onToggleWishlist(detail_events.ToggleWishlist event, Emitter<ProductDetailState> emit) async {
    emit(ProductDetailLoading());
    try {
      final wishlistBloc = BlocProvider.of<WishlistBloc>(event.context);
      final wishlist = await getWishlist();
      final isInWishlist = wishlist.items.any((item) => item.product.id == event.product.id);
      if (isInWishlist) {
        await removeFromWishlist(event.product.id);
        wishlistBloc.add(wishlist_events.RemoveFromWishlist(event.product.id));
      } else {
        await addToWishlist(event.product);
        wishlistBloc.add(wishlist_events.AddToWishlist(event.product));
      }
      emit(ProductDetailInitial());
    } catch (e) {
      emit(ProductDetailError('Failed to toggle wishlist: ${e.toString()}'));
    }
  }
}
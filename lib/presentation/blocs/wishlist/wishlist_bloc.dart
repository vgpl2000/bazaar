import 'package:bazaar/domain/usecases/add_to_wishlist.dart';
import 'package:bazaar/domain/usecases/get_wishlist.dart';
import 'package:bazaar/domain/usecases/remove_from_wishlist.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'wishlist_event.dart' as wishlist_events;
import 'wishlist_state.dart';

class WishlistBloc extends Bloc<wishlist_events.WishlistEvent, WishlistState> {
  final GetWishlist getWishlist;
  final AddToWishlist addToWishlist;
  final RemoveFromWishlist removeFromWishlist;

  WishlistBloc({
    required this.getWishlist,
    required this.addToWishlist,
    required this.removeFromWishlist,
  }) : super(WishlistLoading()) {
    on<wishlist_events.LoadWishlist>(_onLoadWishlist);
    on<wishlist_events.AddToWishlist>(_onAddToWishlist);
    on<wishlist_events.RemoveFromWishlist>(_onRemoveFromWishlist);
  }

  Future<void> _onLoadWishlist(wishlist_events.LoadWishlist event, Emitter<WishlistState> emit) async {
    emit(WishlistLoading());
    try {
      final wishlist = await getWishlist();
      emit(WishlistLoaded(wishlist));
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }

  Future<void> _onAddToWishlist(wishlist_events.AddToWishlist event, Emitter<WishlistState> emit) async {
    try {
      await addToWishlist(event.product);
      final wishlist = await getWishlist();
      emit(WishlistLoaded(wishlist));
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }

  Future<void> _onRemoveFromWishlist(wishlist_events.RemoveFromWishlist event, Emitter<WishlistState> emit) async {
    try {
      await removeFromWishlist(event.productId);
      final wishlist = await getWishlist();
      emit(WishlistLoaded(wishlist));
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }
}
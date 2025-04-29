import 'package:bazaar/domain/usecases/add_to_wishlist.dart';
import 'package:bazaar/domain/usecases/get_wishlist.dart';
import 'package:bazaar/domain/usecases/remove_from_wishlist.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'wishlist_event.dart' as WishlistEvents;
import 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvents.WishlistEvent, WishlistState> {
  final GetWishlist getWishlist;
  final AddToWishlist addToWishlist;
  final RemoveFromWishlist removeFromWishlist;

  WishlistBloc({
    required this.getWishlist,
    required this.addToWishlist,
    required this.removeFromWishlist,
  }) : super(WishlistLoading()) {
    on<WishlistEvents.LoadWishlist>(_onLoadWishlist);
    on<WishlistEvents.AddToWishlist>(_onAddToWishlist);
    on<WishlistEvents.RemoveFromWishlist>(_onRemoveFromWishlist);
  }

  Future<void> _onLoadWishlist(WishlistEvents.LoadWishlist event, Emitter<WishlistState> emit) async {
    emit(WishlistLoading());
    try {
      final wishlist = await getWishlist();
      emit(WishlistLoaded(wishlist));
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }

  Future<void> _onAddToWishlist(WishlistEvents.AddToWishlist event, Emitter<WishlistState> emit) async {
    try {
      await addToWishlist(event.product);
      final wishlist = await getWishlist();
      emit(WishlistLoaded(wishlist));
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }

  Future<void> _onRemoveFromWishlist(WishlistEvents.RemoveFromWishlist event, Emitter<WishlistState> emit) async {
    try {
      await removeFromWishlist(event.productId);
      final wishlist = await getWishlist();
      emit(WishlistLoaded(wishlist));
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }
}
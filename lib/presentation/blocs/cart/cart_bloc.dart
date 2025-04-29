import 'package:bazaar/domain/usecases/add_to_cart.dart';
import 'package:bazaar/domain/usecases/get_cart.dart';
import 'package:bazaar/domain/usecases/remove_from_cart.dart';
import 'package:bazaar/domain/usecases/update_cart_quantity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bazaar/presentation/blocs/cart/cart_event.dart' as CartEvents;
import 'package:bazaar/presentation/blocs/cart/cart_state.dart';

class CartBloc extends Bloc<CartEvents.CartEvent, CartState> {
  final GetCart getCart;
  final AddToCart addToCart;
  final RemoveFromCart removeFromCart;
  final UpdateCartQuantity updateCartQuantity;

  CartBloc({
    required this.getCart,
    required this.addToCart,
    required this.removeFromCart,
    required this.updateCartQuantity,
  }) : super(CartInitial()) {
    on<CartEvents.LoadCart>(_onLoadCart);
    on<CartEvents.AddToCart>(_onAddToCart);
    on<CartEvents.RemoveFromCart>(_onRemoveFromCart);
    on<CartEvents.UpdateCartQuantity>(_onUpdateCartQuantity);
  }

  Future<void> _onLoadCart(CartEvents.LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final cart = await getCart();
      emit(CartLoaded(cart));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onAddToCart(CartEvents.AddToCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      await addToCart(event.product);
      final cart = await getCart();
      emit(CartLoaded(cart));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onRemoveFromCart(CartEvents.RemoveFromCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      await removeFromCart(event.productId);
      final cart = await getCart();
      emit(CartLoaded(cart));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onUpdateCartQuantity(CartEvents.UpdateCartQuantity event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      await updateCartQuantity(event.productId, event.quantity);
      final cart = await getCart();
      emit(CartLoaded(cart));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
}
import 'package:bazaar/domain/usecases/checkout_order.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bazaar/presentation/blocs/checkout/checkout_event.dart' as checkout_events;
import 'package:bazaar/presentation/blocs/checkout/checkout_state.dart';

class CheckoutBloc extends Bloc<checkout_events.CheckoutEvent, CheckoutState> {
  final CheckoutOrder checkoutOrder;

  CheckoutBloc({required this.checkoutOrder}) : super(CheckoutInitial()) {
    on<checkout_events.PlaceOrder>(_onPlaceOrder);
  }

  Future<void> _onPlaceOrder(
      checkout_events.PlaceOrder event, Emitter<CheckoutState> emit) async {
    emit(CheckoutLoading());
    try {
      await checkoutOrder(event.address, event.paymentDetails);
      emit(CheckoutSuccess());
    } catch (e) {
      emit(CheckoutError(e.toString()));
    }
  }
}
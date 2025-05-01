import 'package:equatable/equatable.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object> get props => [];
}

class PlaceOrder extends CheckoutEvent {
  final String address;
  final String paymentDetails;

  const PlaceOrder({required this.address, required this.paymentDetails});

  @override
  List<Object> get props => [address, paymentDetails];
}
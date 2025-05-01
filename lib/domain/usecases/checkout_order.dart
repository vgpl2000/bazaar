import 'package:bazaar/data/repositories/cart_repository_impl.dart';

class CheckoutOrder {
  final CartRepositoryImpl cartRepository;

  CheckoutOrder(this.cartRepository);

  Future<void> call(String address, String paymentDetails) async {
    if (address.isEmpty || paymentDetails.isEmpty) {
      throw Exception('Address and payment details are required');
    }
    // Simulate order processing (e.g., API call)
    await Future.delayed(const Duration(seconds: 1));
    // Clear cart after successful checkout
    await cartRepository.clearCart();
  }
}
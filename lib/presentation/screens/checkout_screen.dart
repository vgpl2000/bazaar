import 'package:bazaar/presentation/blocs/cart/cart_bloc.dart';
import 'package:bazaar/presentation/blocs/cart/cart_event.dart' as CartEvents;
import 'package:bazaar/presentation/blocs/cart/cart_state.dart';
import 'package:bazaar/presentation/blocs/checkout/checkout_bloc.dart';
import 'package:bazaar/presentation/blocs/checkout/checkout_event.dart' as CheckoutEvents;
import 'package:bazaar/presentation/blocs/checkout/checkout_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger LoadCart event to ensure cart is loaded
    context.read<CartBloc>().add(CartEvents.LoadCart());

    final TextEditingController addressController = TextEditingController();
    final TextEditingController paymentController = TextEditingController();

    return BlocListener<CheckoutBloc, CheckoutState>(
      listener: (context, state) {
        if (state is CheckoutSuccess) {
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: Text(
                'Success',
                style: GoogleFonts.farro(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF212121), // Deep Charcoal
                  fontSize: 17,
                ),
              ),
              content: Text(
                'Order placed successfully!',
                style: GoogleFonts.farro(
                  color: const Color(0xFF757575), // Slate Gray
                  fontSize: 15,
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  child: Text(
                    'OK',
                    style: GoogleFonts.farro(
                      color: const Color(0xFF2E7D32), // Teal Blue
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                ),
              ],
            ),
          );
        } else if (state is CheckoutError) {
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: Text(
                'Error',
                style: GoogleFonts.farro(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF212121), // Deep Charcoal
                  fontSize: 17,
                ),
              ),
              content: Text(
                state.message,
                style: GoogleFonts.farro(
                  color: const Color(0xFF757575), // Slate Gray
                  fontSize: 15,
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  child: Text(
                    'OK',
                    style: GoogleFonts.farro(
                      color: const Color(0xFF2E7D32), // Teal Blue
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        }
      },
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            'Checkout',
            style: GoogleFonts.farro(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF212121), // Deep Charcoal
            ),
          ),
          backgroundColor: const Color(0xFF2E7D32), // Teal Blue
          border: null,
        ),
        child: SafeArea(
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              double total = 0;
              List cartItems = [];
              if (cartState is CartLoaded) {
                cartItems = cartState.cart.items;
                total = cartState.cart.items.fold(
                    0, (sum, item) => sum + item.product.price * item.quantity);
              }

              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order Summary',
                            style: GoogleFonts.farro(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF212121), // Deep Charcoal
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (cartItems.isEmpty)
                            Text(
                              'Your cart is empty',
                              style: GoogleFonts.farro(
                                fontSize: 16,
                                color: const Color(0xFF757575), // Slate Gray
                              ),
                            )
                          else
                            ...cartItems.map((item) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.product.title,
                                      style: GoogleFonts.farro(
                                        fontSize: 16,
                                        color: const Color(0xFF212121),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '\$${item.product.price.toStringAsFixed(2)} x ${item.quantity}',
                                    style: GoogleFonts.farro(
                                      fontSize: 16,
                                      color: const Color(0xFF2E7D32),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          const SizedBox(height: 16),
                          Text(
                            'Total: \$${total.toStringAsFixed(2)}',
                            style: GoogleFonts.farro(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF2E7D32), // Teal Blue
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Shipping Address',
                            style: GoogleFonts.farro(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF212121),
                            ),
                          ),
                          const SizedBox(height: 8),
                          CupertinoTextField(
                            controller: addressController,
                            placeholder: 'Enter your address',
                            style: GoogleFonts.farro(
                              fontSize: 16,
                              color: const Color(0xFF212121),
                            ),
                            placeholderStyle: GoogleFonts.farro(
                              fontSize: 16,
                              color: const Color(0xFF757575),
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFB0BEC5), // Warm Gray
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(12),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Payment Details',
                            style: GoogleFonts.farro(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF212121),
                            ),
                          ),
                          const SizedBox(height: 8),
                          CupertinoTextField(
                            controller: paymentController,
                            placeholder: 'Enter card details',
                            style: GoogleFonts.farro(
                              fontSize: 16,
                              color: const Color(0xFF212121),
                            ),
                            placeholderStyle: GoogleFonts.farro(
                              fontSize: 16,
                              color: const Color(0xFF757575),
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFB0BEC5), // Warm Gray
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(12),
                          ),
                          const SizedBox(height: 24),
                          BlocBuilder<CheckoutBloc, CheckoutState>(
                            builder: (context, checkoutState) {
                              return CupertinoButton.filled(
                                onPressed: checkoutState is CheckoutLoading ||
                                    cartItems.isEmpty
                                    ? null
                                    : () {
                                  context.read<CheckoutBloc>().add(
                                    CheckoutEvents.PlaceOrder(
                                      address: addressController.text,
                                      paymentDetails:
                                      paymentController.text,
                                    ),
                                  );
                                },
                                child: Text(
                                  'Place Order',
                                  style: GoogleFonts.farro(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: CupertinoColors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (context.watch<CheckoutBloc>().state is CheckoutLoading)
                    Container(
                      color: CupertinoColors.black.withOpacity(0.3),
                      child: const Center(
                        child: CupertinoActivityIndicator(radius: 20),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
import 'package:bazaar/data/models/product_model.dart';
import 'package:bazaar/data/repositories/cart_repository_impl.dart';
import 'package:bazaar/domain/usecases/add_to_cart.dart';
import 'package:bazaar/domain/usecases/get_cart.dart';
import 'package:bazaar/domain/usecases/remove_from_cart.dart';
import 'package:bazaar/domain/usecases/update_cart_quantity.dart';
import 'package:bazaar/presentation/blocs/cart/cart_bloc.dart';
import 'package:bazaar/presentation/blocs/cart/cart_event.dart' as CartEvents;
import 'package:bazaar/presentation/blocs/cart/cart_state.dart';
import 'package:bazaar/presentation/screens/checkout_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartBloc(
        getCart: GetCart(CartRepositoryImpl()),
        addToCart: AddToCart(CartRepositoryImpl()),
        removeFromCart: RemoveFromCart(CartRepositoryImpl()),
        updateCartQuantity: UpdateCartQuantity(CartRepositoryImpl()),
      )..add(CartEvents.LoadCart()),
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text(
                'Cart',
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
              child: Stack(
                children: [
                  if (state is CartLoading)
                    const Center(child: CupertinoActivityIndicator(radius: 20)),
                  if (state is CartLoaded)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final padding =
                        constraints.maxWidth > 600 ? 32.0 : 16.0;
                        final cart = state.cart;
                        final totalPrice = cart.items.fold(
                            0.0,
                                (sum, item) =>
                            sum + item.product.price * item.quantity);

                        return cart.items.isEmpty
                            ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                CupertinoIcons.cart,
                                size: 64,
                                color: Color(0xFF757575), // Slate Gray
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Your cart is empty',
                                style: GoogleFonts.farro(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF757575),
                                ),
                              ),
                            ],
                          ),
                        )
                            : SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(padding),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your Cart',
                                  style: GoogleFonts.farro(
                                    fontSize:
                                    constraints.maxWidth > 600
                                        ? 28
                                        : 24,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF212121),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ...cart.items.map((item) {
                                  return _buildCartItem(
                                    context,
                                    item.product,
                                    item.quantity,
                                    padding,
                                  );
                                }),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total:',
                                      style: GoogleFonts.farro(
                                        fontSize: constraints.maxWidth >
                                            600
                                            ? 24
                                            : 20,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF212121),
                                      ),
                                    ),
                                    Text(
                                      '\$${totalPrice.toStringAsFixed(2)}',
                                      style: GoogleFonts.farro(
                                        fontSize: constraints.maxWidth >
                                            600
                                            ? 24
                                            : 20,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF2E7D32),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                CupertinoButton.filled(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) =>
                                        const CheckoutScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Proceed to Checkout',
                                    style: GoogleFonts.farro(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: CupertinoColors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  if (state is CartError)
                    Center(
                      child: Text(
                        state.message,
                        style: GoogleFonts.farro(
                          fontSize: 16,
                          color: CupertinoColors.systemRed,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCartItem(
      BuildContext context, ProductModel product, int quantity, double padding) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFB0BEC5), // Warm Gray
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.network(
            product.image,
            width: 60,
            height: 60,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              CupertinoIcons.exclamationmark_triangle,
              color: CupertinoColors.systemRed,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: GoogleFonts.farro(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF212121), // Deep Charcoal
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: GoogleFonts.farro(
                    fontSize: 14,
                    color: const Color(0xFF2E7D32), // Teal Blue
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(
                  CupertinoIcons.minus_circle,
                  color: Color(0xFF2E7D32), // Teal Blue
                  size: 24,
                ),
                onPressed: () {
                  context.read<CartBloc>().add(
                    CartEvents.UpdateCartQuantity(
                      product.id,
                      quantity - 1,
                    ),
                  );
                },
              ),
              Text(
                '$quantity',
                style: GoogleFonts.farro(
                  fontSize: 16,
                  color: const Color(0xFF212121), // Deep Charcoal
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(
                  CupertinoIcons.plus_circle,
                  color: Color(0xFF2E7D32), // Teal Blue
                  size: 24,
                ),
                onPressed: () {
                  context.read<CartBloc>().add(
                    CartEvents.UpdateCartQuantity(
                      product.id,
                      quantity + 1,
                    ),
                  );
                },
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(
                  CupertinoIcons.trash,
                  color: CupertinoColors.systemRed,
                  size: 24,
                ),
                onPressed: () {
                  context.read<CartBloc>().add(
                    CartEvents.RemoveFromCart(product.id),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
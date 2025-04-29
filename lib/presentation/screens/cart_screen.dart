import 'package:bazaar/data/repositories/cart_repository_impl.dart';
import 'package:bazaar/domain/usecases/add_to_cart.dart';
import 'package:bazaar/domain/usecases/get_cart.dart';
import 'package:bazaar/domain/usecases/remove_from_cart.dart';
import 'package:bazaar/domain/usecases/update_cart_quantity.dart';
import 'package:bazaar/presentation/blocs/cart/cart_bloc.dart';
import 'package:bazaar/presentation/blocs/cart/cart_event.dart' as CartEvents;
import 'package:bazaar/presentation/blocs/cart/cart_state.dart';
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
      child: CupertinoPageScaffold(
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
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoading) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (state is CartLoaded) {
                final cart = state.cart;
                if (cart.items.isEmpty) {
                  return Center(
                    child: Text(
                      'Your cart is empty',
                      style: GoogleFonts.farro(
                        fontSize: 18,
                        color: const Color(0xFF757575), // Slate Gray
                      ),
                    ),
                  );
                }
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final padding = constraints.maxWidth > 600 ? 32.0 : 16.0;
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.all(padding),
                            itemCount: cart.items.length,
                            itemBuilder: (context, index) {
                              final item = cart.items[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: CupertinoColors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: CupertinoColors.black.withOpacity(0.05),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      Image.network(
                                        item.product.image,
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
                                              item.product.title,
                                              style: GoogleFonts.farro(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xFF212121), // Deep Charcoal
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '\$${item.product.price.toStringAsFixed(2)}',
                                              style: GoogleFonts.farro(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
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
                                              color: Color(0xFF2E7D32),
                                            ),
                                            onPressed: () {
                                              context.read<CartBloc>().add(
                                                CartEvents.UpdateCartQuantity(
                                                  item.product.id,
                                                  item.quantity - 1,
                                                ),
                                              );
                                            },
                                          ),
                                          Text(
                                            '${item.quantity}',
                                            style: GoogleFonts.farro(
                                              fontSize: 16,
                                              color: const Color(0xFF212121),
                                            ),
                                          ),
                                          CupertinoButton(
                                            padding: EdgeInsets.zero,
                                            child: const Icon(
                                              CupertinoIcons.plus_circle,
                                              color: Color(0xFF2E7D32),
                                            ),
                                            onPressed: () {
                                              context.read<CartBloc>().add(
                                                CartEvents.UpdateCartQuantity(
                                                  item.product.id,
                                                  item.quantity + 1,
                                                ),
                                              );
                                            },
                                          ),
                                          CupertinoButton(
                                            padding: EdgeInsets.zero,
                                            child: const Icon(
                                              CupertinoIcons.trash,
                                              color: CupertinoColors.systemRed,
                                            ),
                                            onPressed: () {
                                              context.read<CartBloc>().add(
                                                CartEvents.RemoveFromCart(item.product.id),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(padding),
                          decoration: const BoxDecoration(
                            color: CupertinoColors.white,
                            boxShadow: [
                              BoxShadow(
                                color: CupertinoColors.black,
                                blurRadius: 6,
                                offset: Offset(0, -2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total:',
                                    style: GoogleFonts.farro(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF212121), // Deep Charcoal
                                    ),
                                  ),
                                  Text(
                                    '\$${cart.totalPrice.toStringAsFixed(2)}',
                                    style: GoogleFonts.farro(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF2E7D32), // Teal Blue
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              CupertinoButton.filled(
                                onPressed: () {
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (context) => CupertinoAlertDialog(
                                      title: Text(
                                        'Checkout',
                                        style: GoogleFonts.farro(
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF212121),
                                        ),
                                      ),
                                      content: Text(
                                        'Proceeding to checkout (placeholder)',
                                        style: GoogleFonts.farro(
                                          color: const Color(0xFF757575),
                                        ),
                                      ),
                                      actions: [
                                        CupertinoDialogAction(
                                          child: Text(
                                            'OK',
                                            style: GoogleFonts.farro(
                                              color: const Color(0xFF2E7D32),
                                            ),
                                          ),
                                          onPressed: () => Navigator.pop(context),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Text(
                                  'Checkout',
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
                      ],
                    );
                  },
                );
              } else if (state is CartError) {
                return Center(
                  child: CupertinoButton(
                    child: Text(
                      'Error: ${state.message}\nTap to Retry',
                      style: GoogleFonts.farro(
                        color: CupertinoColors.systemRed,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      context.read<CartBloc>().add(CartEvents.LoadCart());
                    },
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
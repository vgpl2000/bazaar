import 'package:bazaar/presentation/blocs/cart/cart_bloc.dart';
import 'package:bazaar/presentation/blocs/cart/cart_event.dart' as cart_events;
import 'package:bazaar/presentation/blocs/wishlist/wishlist_bloc.dart';
import 'package:bazaar/presentation/blocs/wishlist/wishlist_event.dart' as wishlist_events;
import 'package:bazaar/presentation/blocs/wishlist/wishlist_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: const CupertinoThemeData(
        primaryColor: Color(0xFF2E7D32),
      ),
      child: CupertinoPageScaffold(
        backgroundColor: CupertinoColors.white,
        navigationBar: CupertinoNavigationBar(
          padding: const EdgeInsetsDirectional.symmetric(vertical: 5),
          middle: Image.asset(
            'assets/images/logo.png',
            height: 40,
            fit: BoxFit.contain,
          ),
          backgroundColor: const Color(0xFF2E7D32), // Teal Blue
          border: null,
        ),
        child: SafeArea(
          child: BlocBuilder<WishlistBloc, WishlistState>(
            builder: (context, state) {
              if (state is WishlistLoading) {
                //Loading...
                return const Center(child: CupertinoActivityIndicator(color: Color(0xFF2E7D32)));
              } else if (state is WishlistLoaded) {
                // Empty Wishlist
                final wishlist = state.wishlist;
                if (wishlist.items.isEmpty) {
                  return Center(
                    child: Text(
                      'Your wishlist is empty',
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
                    return ListView.builder(
                      padding: EdgeInsets.all(padding),
                      itemCount: wishlist.items.length,
                      itemBuilder: (context, index) {
                        final item = wishlist.items[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: CupertinoColors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: CupertinoColors.black.withValues(alpha: 0.05),
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
                                        CupertinoIcons.cart,
                                        color: Color(0xFF2E7D32), // Teal Blue
                                        size: 24,
                                      ),
                                      onPressed: () {
                                        context.read<CartBloc>().add(
                                          cart_events.AddToCart(item.product),
                                        );
                                        // Optionally remove from wishlist
                                        context.read<WishlistBloc>().add(
                                          wishlist_events.RemoveFromWishlist(item.product.id),
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
                                        context.read<WishlistBloc>().add(
                                          wishlist_events.RemoveFromWishlist(item.product.id),
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
                    );
                  },
                );
              } else if (state is WishlistError) {
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
                      context.read<WishlistBloc>().add(wishlist_events.LoadWishlist());
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
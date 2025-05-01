import 'package:bazaar/data/repositories/wishlist_repository_impl.dart';
import 'package:bazaar/domain/usecases/add_to_wishlist.dart';
import 'package:bazaar/domain/usecases/get_wishlist.dart';
import 'package:bazaar/domain/usecases/remove_from_wishlist.dart';
import 'package:bazaar/presentation/blocs/cart/cart_bloc.dart';
import 'package:bazaar/presentation/blocs/cart/cart_event.dart' as CartEvents;
import 'package:bazaar/presentation/blocs/wishlist/wishlist_bloc.dart';
import 'package:bazaar/presentation/blocs/wishlist/wishlist_event.dart' as WishlistEvents;
import 'package:bazaar/presentation/blocs/wishlist/wishlist_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WishlistBloc(
        getWishlist: GetWishlist(WishlistRepositoryImpl()),
        addToWishlist: AddToWishlist(WishlistRepositoryImpl()),
        removeFromWishlist: RemoveFromWishlist(WishlistRepositoryImpl()),
      )..add(WishlistEvents.LoadWishlist()),
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
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
                return const Center(child: CupertinoActivityIndicator());
              } else if (state is WishlistLoaded) {
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
                                          CartEvents.AddToCart(item.product),
                                        );
                                        // Optionally remove from wishlist
                                        context.read<WishlistBloc>().add(
                                          WishlistEvents.RemoveFromWishlist(item.product.id),
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
                                          WishlistEvents.RemoveFromWishlist(item.product.id),
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
                      context.read<WishlistBloc>().add(WishlistEvents.LoadWishlist());
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
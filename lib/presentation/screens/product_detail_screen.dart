import 'package:bazaar/data/models/product_model.dart';
import 'package:bazaar/data/repositories/wishlist_repository_impl.dart';
import 'package:bazaar/domain/usecases/add_to_wishlist.dart';
import 'package:bazaar/domain/usecases/get_wishlist.dart';
import 'package:bazaar/domain/usecases/remove_from_wishlist.dart';
import 'package:bazaar/presentation/blocs/product_detail/product_detail_bloc.dart';
import 'package:bazaar/presentation/blocs/product_detail/product_detail_event.dart' as DetailEvents;
import 'package:bazaar/presentation/blocs/product_detail/product_detail_state.dart';
import 'package:bazaar/presentation/blocs/wishlist/wishlist_bloc.dart';
import 'package:bazaar/presentation/blocs/wishlist/wishlist_state.dart';
import 'package:bazaar/presentation/screens/cart_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProductDetailBloc(
            addToWishlist: AddToWishlist(WishlistRepositoryImpl()),
            removeFromWishlist: RemoveFromWishlist(WishlistRepositoryImpl()),
            getWishlist: GetWishlist(WishlistRepositoryImpl()),
          ),
        ),
      ],
      child: BlocListener<ProductDetailBloc, ProductDetailState>(
        listenWhen: (previous, current) =>
        current is ProductDetailSuccess || current is ProductDetailError,
        listener: (context, state) {
          if (state is ProductDetailSuccess) {
            showCupertinoDialog(
              context: context,
              builder: (context) => Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: MediaQuery.of(context).size.height * 0.3,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFB0BEC5), // Warm Gray
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CupertinoAlertDialog(
                  title: Text(
                    state.message.contains('Cart') ? 'Cart' : 'Wishlist',
                    style: GoogleFonts.farro(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF212121), // Deep Charcoal
                      fontSize: 18,
                    ),
                  ),
                  content: Text(
                    state.message,
                    style: GoogleFonts.farro(
                      color: const Color(0xFF757575), // Slate Gray
                      fontSize: 16,
                    ),
                  ),
                  actions: [
                    CupertinoDialogAction(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32), // Teal Blue
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'OK',
                          style: GoogleFonts.farro(
                            color: CupertinoColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is ProductDetailError) {
            showCupertinoDialog(
              context: context,
              builder: (context) => Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: MediaQuery.of(context).size.height * 0.3,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFB0BEC5), // Warm Gray
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CupertinoAlertDialog(
                  title: Text(
                    'Error',
                    style: GoogleFonts.farro(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF212121), // Deep Charcoal
                      fontSize: 18,
                    ),
                  ),
                  content: Text(
                    state.message,
                    style: GoogleFonts.farro(
                      color: const Color(0xFF757575), // Slate Gray
                      fontSize: 16,
                    ),
                  ),
                  actions: [
                    CupertinoDialogAction(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32), // Teal Blue
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'OK',
                          style: GoogleFonts.farro(
                            color: CupertinoColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            );
          }
        },
        child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
          builder: (context, state) {
            return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                middle: Text(
                  'Product Details',
                  style: GoogleFonts.farro(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF212121), // Deep Charcoal
                  ),
                ),
                backgroundColor: const Color(0xFF2E7D32), // Teal Blue
                border: null,
                trailing: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(
                    CupertinoIcons.cart,
                    color: CupertinoColors.white,
                    size: 24,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const CartScreen(),
                      ),
                    );
                  },
                ),
              ),
              child: Stack(
                children: [
                  SafeArea(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final imageSize = constraints.maxWidth > 600 ? constraints.maxWidth * 0.4 : constraints.maxWidth * 0.6;
                        final padding = constraints.maxWidth > 600 ? 32.0 : 16.0;

                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Hero(
                                  tag: 'product-image-${product.id}',
                                  child: Image.network(
                                    product.image,
                                    height: imageSize,
                                    width: imageSize,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) => const Icon(
                                      CupertinoIcons.exclamationmark_triangle,
                                      color: CupertinoColors.systemRed,
                                      size: 100,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(padding),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.title,
                                      style: GoogleFonts.farro(
                                        fontSize: constraints.maxWidth > 600 ? 28 : 24,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF212121), // Deep Charcoal
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '\$${product.price.toStringAsFixed(2)}',
                                      style: GoogleFonts.farro(
                                        fontSize: constraints.maxWidth > 600 ? 24 : 20,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF2E7D32), // Teal Blue
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      product.description,
                                      style: GoogleFonts.farro(
                                        fontSize: constraints.maxWidth > 600 ? 18 : 16,
                                        color: const Color(0xFF757575), // Slate Gray
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    BlocBuilder<WishlistBloc, WishlistState>(
                                      builder: (context, wishlistState) {
                                        bool isInWishlist = false;
                                        if (wishlistState is WishlistLoaded) {
                                          isInWishlist = wishlistState.wishlist.items
                                              .any((item) => item.product.id == product.id);
                                        }
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: CupertinoButton.filled(
                                                onPressed: state is ProductDetailLoading
                                                    ? null
                                                    : () {
                                                  context.read<ProductDetailBloc>().add(
                                                    DetailEvents.AddToCart(
                                                        product.id, product, context),
                                                  );
                                                },
                                                child: Text(
                                                  'Add to Cart',
                                                  style: GoogleFonts.farro(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: CupertinoColors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            CupertinoButton(
                                              onPressed: state is ProductDetailLoading
                                                  ? null
                                                  : () {
                                                context.read<ProductDetailBloc>().add(
                                                  DetailEvents.ToggleWishlist(
                                                      product, context),
                                                );
                                              },
                                              child: Icon(
                                                isInWishlist
                                                    ? CupertinoIcons.heart_fill
                                                    : CupertinoIcons.heart,
                                                color: const Color(0xFF2E7D32), // Teal Blue
                                                size: 28,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  if (state is ProductDetailLoading)
                    Container(
                      color: CupertinoColors.black.withOpacity(0.3),
                      child: const Center(
                        child: CupertinoActivityIndicator(radius: 20),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
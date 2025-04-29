import 'package:bazaar/data/models/product_model.dart';
import 'package:bazaar/presentation/blocs/product_detail/product_detail_bloc.dart';
import 'package:bazaar/presentation/blocs/product_detail/product_detail_event.dart';
import 'package:bazaar/presentation/blocs/product_detail/product_detail_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductDetailBloc(),
      child: BlocListener<ProductDetailBloc, ProductDetailState>(
        listener: (context, state) {
          if (state is ProductDetailSuccess) {
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
          } else if (state is ProductDetailError) {
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
              'Product Details',
              style: GoogleFonts.farro(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF212121), // Deep Charcoal
              ),
            ),
            backgroundColor: const Color(0xFF2E7D32), // Teal Blue
            border: null, // Clean look
          ),
          child: SafeArea(
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: CupertinoButton.filled(
                                    onPressed: () {
                                      context.read<ProductDetailBloc>().add(AddToCart(product.id));
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
                                  onPressed: () {
                                    context.read<ProductDetailBloc>().add(AddToWishlist(product.id));
                                  },
                                  child: const Icon(
                                    CupertinoIcons.heart,
                                    color: Color(0xFF2E7D32), // Teal Blue
                                    size: 28,
                                  ),
                                ),
                              ],
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
        ),
      ),
    );
  }
}
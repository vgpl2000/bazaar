import 'package:bazaar/data/repositories/product_repository_impl.dart';
import 'package:bazaar/domain/usecases/get_products.dart';
import 'package:bazaar/presentation/blocs/product/product_bloc.dart';
import 'package:bazaar/presentation/blocs/product/product_event.dart';
import 'package:bazaar/presentation/blocs/product/product_state.dart';
import 'package:bazaar/presentation/screens/cart_screen.dart';
import 'package:bazaar/presentation/screens/product_detail_screen.dart';
import 'package:bazaar/presentation/screens/wishlist_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/services/api_services.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(
        GetProducts(ProductRepositoryImpl(ApiService())),
      )..add(FetchProducts()),
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Image.asset(
            'assets/images/logo.png',
            height: 40,
            fit: BoxFit.contain,
          ),
          backgroundColor: const Color(0xFF2E7D32), // Teal Blue
          border: null,
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(
              CupertinoIcons.heart_fill,
              color: CupertinoColors.white,
              size: 24,
            ),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const WishlistScreen(),
                ),
              );
            },
          ),
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
        child: SafeArea(
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (state is ProductLoaded) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                    final itemWidth = constraints.maxWidth / crossAxisCount;
                    final imageSize = itemWidth * 0.7;

                    return GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => ProductDetailScreen(product: product),
                              ),
                            );
                          },
                          child: Container(
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Center(
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
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  child: Text(
                                    product.title,
                                    style: GoogleFonts.farro(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF212121), // Deep Charcoal
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  child: Text(
                                    '\$${product.price.toStringAsFixed(2)}',
                                    style: GoogleFonts.farro(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF2E7D32), // Teal Blue
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              } else if (state is ProductError) {
                return Center(
                  child: CupertinoButton(
                    child: Text(
                      'Error: ${state.message}\nTap to Retry',
                      style: GoogleFonts.farro(
                        color: CupertinoColors.systemRed,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      context.read<ProductBloc>().add(FetchProducts());
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
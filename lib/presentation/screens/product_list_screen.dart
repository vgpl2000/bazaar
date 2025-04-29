import 'package:bazaar/data/repositories/product_repository_impl.dart';
import 'package:bazaar/domain/usecases/get_products.dart';
import 'package:bazaar/presentation/blocs/product/product_bloc.dart';
import 'package:bazaar/presentation/blocs/product/product_event.dart';
import 'package:bazaar/presentation/blocs/product/product_state.dart';
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
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Bazaar Products'),
          backgroundColor: Color(0xFF2E7D32), // Teal Blue
        ),
        child: SafeArea(
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (state is ProductLoaded) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    // Responsive grid: 2 columns for mobile, 3 for tablet
                    final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                    final itemWidth = constraints.maxWidth / crossAxisCount;
                    final imageSize = itemWidth * 0.6;

                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return CupertinoContextMenu(
                          actions: [
                            CupertinoContextMenuAction(
                              child: const Text('View Details'),
                              onPressed: () {
                                Navigator.pop(context); // Close context menu
                                // Navigation to ProductDetailScreen will be added in Feature 4
                              },
                            ),
                          ],
                          child: Container(
                            decoration: BoxDecoration(
                              color: CupertinoColors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: CupertinoColors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Center(
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
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    product.title,
                                    style: GoogleFonts.farro(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF212121), // Deep Charcoal
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    '\$${product.price.toStringAsFixed(2)}',
                                    style: GoogleFonts.farro(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF2E7D32), // Teal Blue
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    product.description,
                                    style: GoogleFonts.farro(
                                      fontSize: 12,
                                      color: const Color(0xFF757575), // Slate Gray
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
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
import 'package:bazaar/data/models/product_model.dart';
import 'package:bazaar/data/repositories/product_repository_impl.dart';
import 'package:bazaar/data/services/api_services.dart';
import 'package:bazaar/domain/usecases/get_products.dart';
import 'package:bazaar/presentation/blocs/cart/cart_bloc.dart';
import 'package:bazaar/presentation/blocs/cart/cart_state.dart';
import 'package:bazaar/presentation/blocs/product/product_bloc.dart';
import 'package:bazaar/presentation/blocs/product/product_event.dart';
import 'package:bazaar/presentation/blocs/product/product_state.dart';
import 'package:bazaar/presentation/screens/product_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(
        GetProducts(ProductRepositoryImpl(ApiService())),
      )..add(FetchProducts()),
      child: BlocBuilder<CartBloc, CartState>(
        buildWhen: (previous, current) =>
        previous is CartLoaded && current is CartLoaded && previous.cart.items.length != current.cart.items.length,
        builder: (context, cartState) {
          return CupertinoPageScaffold(
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
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(
                      CupertinoIcons.heart,
                      color: CupertinoColors.activeOrange,
                      size: 24,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/wishlist');
                    },
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(
                      CupertinoIcons.cart,
                      color: Color(0xFF57DC5D),
                      size: 24,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/cart');
                    },
                  ),
                ],
              ),
            ),
            child: SafeArea(
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return const Center(child: CupertinoActivityIndicator(radius: 20, color: Color(0xFF2E7D32),));
                  } else if (state is ProductLoaded) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final crossAxisCount = constraints.maxWidth > 600 ? 5 : 3;
                        final padding = constraints.maxWidth > 600 ? 32.0 : 12.0;
                        final childAspectRatio = constraints.maxWidth > 600 ? 0.7 : 0.65;

                        return GridView.builder(
                          padding: EdgeInsets.all(padding),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: childAspectRatio,
                            crossAxisSpacing: padding,
                            mainAxisSpacing: padding,
                          ),
                          itemCount: state.products.length,
                          itemBuilder: (context, index) {
                            final product = state.products[index];
                            return _buildProductCard(context, product, constraints);
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
          );
        },
      ),
    );
  }

  // Single Product Card
  Widget _buildProductCard(
      BuildContext context,
      ProductModel product,
      BoxConstraints constraints,
      ) {
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
              color: CupertinoColors.black.withValues(alpha: 0.05),
              blurRadius: 8,
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
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: GoogleFonts.farro(
                      height: 1.2,
                      fontSize: constraints.maxWidth > 600 ? 16 : 14,
                      fontWeight: FontWeight.w300,
                      color: const Color(0xFF212121), // Deep Charcoal
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: GoogleFonts.farro(
                      fontSize: constraints.maxWidth > 600 ? 22 : 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2E7D32), // Teal Blue
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
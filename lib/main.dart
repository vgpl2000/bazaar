import 'package:bazaar/data/repositories/cart_repository_impl.dart';
import 'package:bazaar/data/repositories/product_repository_impl.dart';
import 'package:bazaar/data/repositories/wishlist_repository_impl.dart';
import 'package:bazaar/data/services/api_services.dart';
import 'package:bazaar/domain/usecases/add_to_cart.dart';
import 'package:bazaar/domain/usecases/add_to_wishlist.dart';
import 'package:bazaar/domain/usecases/checkout_order.dart';
import 'package:bazaar/domain/usecases/get_cart.dart';
import 'package:bazaar/domain/usecases/get_products.dart';
import 'package:bazaar/domain/usecases/get_wishlist.dart';
import 'package:bazaar/domain/usecases/remove_from_cart.dart';
import 'package:bazaar/domain/usecases/remove_from_wishlist.dart';
import 'package:bazaar/domain/usecases/update_cart_quantity.dart';
import 'package:bazaar/presentation/blocs/cart/cart_bloc.dart';
import 'package:bazaar/presentation/blocs/checkout/checkout_bloc.dart';
import 'package:bazaar/presentation/blocs/product/product_bloc.dart';
import 'package:bazaar/presentation/blocs/product/product_event.dart' as product_events;
import 'package:bazaar/presentation/blocs/wishlist/wishlist_bloc.dart';
import 'package:bazaar/presentation/screens/cart_screen.dart';
import 'package:bazaar/presentation/screens/product_list_screen.dart';
import 'package:bazaar/presentation/screens/wishlist_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const BazaarApp());
}

class BazaarApp extends StatelessWidget {
  const BazaarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProductBloc(
            GetProducts(ProductRepositoryImpl(ApiService())),
          )..add(product_events.FetchProducts()),
        ),
        BlocProvider(
          create: (context) => CartBloc(
            getCart: GetCart(CartRepositoryImpl()),
            addToCart: AddToCart(CartRepositoryImpl()),
            removeFromCart: RemoveFromCart(CartRepositoryImpl()),
            updateCartQuantity: UpdateCartQuantity(CartRepositoryImpl()),
          ),
        ),
        BlocProvider(
          create: (context) => WishlistBloc(
            getWishlist: GetWishlist(WishlistRepositoryImpl()),
            addToWishlist: AddToWishlist(WishlistRepositoryImpl()),
            removeFromWishlist: RemoveFromWishlist(WishlistRepositoryImpl()),
          ),
        ),
        BlocProvider(
          create: (context) => CheckoutBloc(
            checkoutOrder: CheckoutOrder(CartRepositoryImpl()),
          ),
        ),
      ],
      child: CupertinoApp(
        debugShowCheckedModeBanner: false,
        title: 'Bazaar',
        theme: const CupertinoThemeData(
          primaryColor: Color(0xFF2E7D32), // Teal Blue
          scaffoldBackgroundColor: Color(0xFFB0BEC5), // Warm Gray
          textTheme: CupertinoTextThemeData(
            textStyle: TextStyle(
              fontFamily: 'Farro',
              color: Color(0xFF212121), // Deep Charcoal
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) =>  const ProductListScreen(),
          '/cart': (context) =>  const CartScreen(),
          '/wishlist': (context) =>  const WishlistScreen(),
        },
      ),
    );
  }
}
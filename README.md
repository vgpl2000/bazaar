Bazaar - E-commerce App
Overview
Bazaar is a Flutter-based e-commerce mobile application that allows users to browse products, manage a cart, maintain a wishlist, and complete checkout. It fetches product data from the FakeStore API and follows Clean Architecture with the BLoC pattern for state management. The app features a modern UI with the Farro font, a Teal Blue (#2E7D32), Deep Charcoal (#212121), Slate Gray (#757575), and Warm Gray (#B0BEC5) color palette, and is responsive for mobile and tablet devices in portrait and landscape orientations.
Features

Product Listing:
Displays a grid of products with thumbnail, title, price, and short description.
Supports loading indicator, error handling, and retry functionality.
Tappable products navigate to details.


Product Details:
Shows full product image, title, price, and description.
Buttons to add to cart or wishlist with confirmation dialogs.


Cart:
Lists cart items with quantity controls and removal.
Displays total price and navigates to checkout.


Wishlist:
Shows wishlist items with options to remove or move to cart.
Handles empty wishlist and errors.


Checkout (Bonus):
Displays cart items, total, shipping address, and payment input.
Places orders with success/error dialogs, clears cart on success.



Setup Instructions

Prerequisites:
Flutter SDK (3.0.0 or later)
Dart (2.17.0 or later)
Git
IDE (e.g., VS Code, Android Studio)


Clone Repository:git clone <repository-url>
cd bazaar


Install Dependencies:flutter pub get


Add Assets:
Place logo.png in assets/images/ (100x40 PNG, "Bazaar" in Farro Bold, #2E7D32).
Update pubspec.yaml:assets:
- assets/images/logo.png




Run the App:flutter run


Requires internet for FakeStore API.
Tested on Android (moto g71 5G) and iOS; supports tablet layouts.



Dependencies

flutter_bloc: ^8.1.3 - State management
http: ^1.1.0 - API requests
google_fonts: ^6.1.0 - Farro font
equatable: ^2.0.5 - Value comparison

Project Structure
Bazaar follows Clean Architecture:

data/: Models (product_model.dart, cart_model.dart), repositories (product_repository_impl.dart), services (api_services.dart).
domain/: Use cases (get_products.dart, add_to_cart.dart), repository interfaces.
presentation/: Screens (product_list_screen.dart), blocs (product_bloc.dart), UI components.

Architecture

State Management: BLoC pattern for reactive UI updates.
API: FakeStore API (https://fakestoreapi.com/products) for product data.
UI: Cupertino widgets, Farro font, Teal Blue buttons/prices, Deep Charcoal titles, Warm Gray backgrounds, rounded cards (12px radius, 0.05 shadow).

Known Limitations

FakeStore API rate limits may cause 429 errors; consider caching for production.
No user authentication (planned as future feature).
Minimal in-code comments; see this README for details.

Future Enhancements

User Authentication: Add login/signup with Firebase for personalized carts/wishlists.
Order History: Display past orders.
Search Products: Add search bar for product filtering.

Contributing

Fork the repository.
Create a feature branch (git checkout -b feature/new-feature).
Commit changes (git commit -m "Add new feature").
Push to branch (git push origin feature/new-feature).
Open a pull request.

License
MIT License. See LICENSE for details.

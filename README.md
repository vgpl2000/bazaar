# Bazaar - E-commerce App

**Bazaar** is a Flutter-based e-commerce mobile application that allows users to browse products, manage a cart, maintain a wishlist, and complete checkout. It fetches product data from the [FakeStore API](https://fakestoreapi.com/products) and follows **Clean Architecture** with the **BLoC pattern** for state management.

The app features a modern UI with the **Farro** font and a color palette of:
- **Teal Blue** `#2E7D32`
- **Deep Charcoal** `#212121`
- **Slate Gray** `#757575`
- **Warm Gray** `#B0BEC5`

The UI is responsive for mobile and tablet devices in both portrait and landscape modes.

---

## ✨ Features

### 🛍 Product Listing
- Grid of products with thumbnail, title, price, and short description.
- Loading indicators, error handling, and retry options.
- Tap a product to view its details.

### 📄 Product Details
- Full image, title, price, and description.
- Buttons to add to cart or wishlist with confirmation dialogs.

### 🛒 Cart
- Lists cart items with quantity controls and removal.
- Shows total price and checkout navigation.

### ❤️ Wishlist
- View wishlist items with options to remove or move to cart.
- Empty and error state handling.

### 💳 Checkout (Bonus)
- Displays cart summary, shipping address, and payment input.
- Order placement with success/error dialogs.
- Clears cart on successful order.

---

## ⚙️ Setup Instructions

### 🔧 Prerequisites
- Flutter SDK (3.0.0 or later)  
- Dart (2.17.0 or later)  
- Git  
- IDE (e.g., VS Code, Android Studio)

### 🚀 Installation

```bash
git clone <repo-url>
cd bazaar
flutter pub get

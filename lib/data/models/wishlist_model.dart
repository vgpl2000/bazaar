import 'package:bazaar/data/models/product_model.dart';
import 'package:equatable/equatable.dart';

class WishlistModel extends Equatable {
  final List<WishlistItem> items;

  const WishlistModel({this.items = const []});

  @override
  List<Object> get props => [items];
}

class WishlistItem extends Equatable {
  final ProductModel product;

  const WishlistItem({required this.product});

  @override
  List<Object> get props => [product];
}
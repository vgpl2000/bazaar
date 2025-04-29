import 'package:bazaar/data/models/product_model.dart';
import 'package:bazaar/domain/repositories/product_repository.dart';

import '../services/api_services.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ApiService apiService;

  ProductRepositoryImpl(this.apiService);

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final data = await apiService.fetchProducts();
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }
}
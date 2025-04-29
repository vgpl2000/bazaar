import 'package:bazaar/data/models/product_model.dart';
import 'package:bazaar/domain/repositories/product_repository.dart';

class GetProducts {
  final ProductRepository repository;

  GetProducts(this.repository);

  Future<List<ProductModel>> call() async {
    return await repository.getProducts();
  }
}
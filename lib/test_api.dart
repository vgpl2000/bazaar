
import 'data/services/api_services.dart';

void main() async {
  final apiService = ApiService();
  try {
    final products = await apiService.fetchProducts();
    print(products);
  } catch (e) {
    print('Error: $e');
  }
}
import 'package:bazaar/domain/usecases/get_products.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bazaar/presentation/blocs/product/product_event.dart' as product_events;
import 'package:bazaar/presentation/blocs/product/product_state.dart';

class ProductBloc extends Bloc<product_events.ProductEvent, ProductState> {
  final GetProducts getProducts;

  ProductBloc(this.getProducts) : super(ProductLoading()) {
    on<product_events.FetchProducts>(_onFetchProducts);
  }

  Future<void> _onFetchProducts(
      product_events.FetchProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final products = await getProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
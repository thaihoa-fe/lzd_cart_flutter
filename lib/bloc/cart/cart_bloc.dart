import 'package:bloc/bloc.dart';
import 'package:flutter_lzd_cart/bloc/cart/cart_event.dart';
import 'package:flutter_lzd_cart/bloc/cart/cart_state.dart';
import 'package:flutter_lzd_cart/repository/cart.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository repository;
  CartBloc({ this.repository }) {
    dispatch(StartFetch());
  }

  @override
  CartState get initialState => CartUnitialized();

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (event is StartFetch) {
      yield* _mapStartFetchToState(event);
    } else if (event is UpdateProduct) {
      yield* _mapUpdateToState(event);
    } else if (event is ToggleSelectProduct) {
      yield* _mapSelectToState(event);
    } else if (event is ToggleSelectAllProducts) {
      yield* _mapSelectAllProductToState(event);
    }
  }

  Stream<CartState> _mapStartFetchToState(StartFetch event) async* {
    yield CartLoading();
    try {
      final products = await repository.fetchCartProducts();
      yield CartLoaded(products: products, selectedProducts: {});
    } catch (e) {
      yield CartError(exception: e);
    }
  }

  Stream<CartState> _mapUpdateToState(UpdateProduct event) async* {
    if (currentState is CartLoaded) {
      final state = (currentState as CartLoaded);
      final index = state.products.indexWhere((p) => p.id == event.product.id);
      state.products[index] = event.product;
      
      final selectedProduct = state.selectedProducts.firstWhere((p) => p.id == event.product.id, orElse: () => null);

      if (selectedProduct != null) {
        state.selectedProducts.remove(selectedProduct);
        if (event.product.quantity > 0)  {
          state.selectedProducts.add(event.product);
        }
      }

      yield state.copyWith(
        products: state.products,
        selectedProducts: state.selectedProducts,
      );
    }
  }


  Stream<CartState> _mapSelectToState(ToggleSelectProduct event) async* {
    if (currentState is CartLoaded) {
      final state = (currentState as CartLoaded);
      final selectedProducts = state.selectedProducts;
      if (selectedProducts.contains(event.product)) {
        selectedProducts.remove(event.product);
      } else {
        selectedProducts.add(event.product);
      }
      yield state.copyWith(selectedProducts: selectedProducts);
    }
  }
  
  Stream<CartState> _mapSelectAllProductToState(ToggleSelectAllProducts event) async* {
    if (currentState is CartLoaded) {
      final state = (currentState as CartLoaded);
      /* already select all products */
      if (state.selectedProducts.length == state.products.length) {
        state.selectedProducts.clear();
      } else {
        state.selectedProducts.addAll(state.products);
      }
      yield state.copyWith(selectedProducts: state.selectedProducts);
    }
  }
}
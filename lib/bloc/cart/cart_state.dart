import 'package:equatable/equatable.dart';
import 'package:flutter_lzd_cart/models/cart_product.dart';

abstract class CartState extends Equatable {
  final bool loading;
  CartState(this.loading, [List props = const []]): super([loading, ...props]);
}

class CartUnitialized extends CartState {
  CartUnitialized(): super(false);
}

class CartError extends CartState {
  final Exception exception;
  CartError({ this.exception }): super(false, [exception]);
}

class CartLoading extends CartState {
  CartLoading(): super(true);
}

class CartLoaded extends CartState {
  final Set<CartProduct> selectedProducts;
  final List<CartProduct> products;
  CartLoaded({ this.products, this.selectedProducts }): super(false, [...selectedProducts, ...products]);

  CartLoaded copyWith({ List<CartProduct> products, Set<CartProduct> selectedProducts  }) {
    return CartLoaded(
      products: products ?? this.products,
      selectedProducts: selectedProducts ?? this.selectedProducts,
    );
  }
}

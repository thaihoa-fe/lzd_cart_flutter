import 'package:equatable/equatable.dart';
import 'package:flutter_lzd_cart/models/cart_product.dart';

abstract class CartEvent extends Equatable {
  CartEvent([List props = const []]): super(props);
}

class StartFetch extends CartEvent {}
class FetchError extends CartEvent {}
class UpdateProduct extends CartEvent {
  final CartProduct product;
  UpdateProduct(this.product): super([product]);
}
class ToggleSelectAllProducts extends CartEvent {}
class ToggleSelectProduct extends CartEvent {
  final CartProduct product;
  ToggleSelectProduct(this.product): super([product]);
}
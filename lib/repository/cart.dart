import 'package:flutter_lzd_cart/models/cart_product.dart';
import 'package:http_client/http_client.dart';
import 'dart:convert';

class CartRepository {
  final Client httpClient;

  const CartRepository(this.httpClient);

  Future<List<CartProduct>> fetchCartProducts() async {
    final response = await httpClient.send(Request(
        'GET', 'https://5d58c6346bf39a0014c6d464.mockapi.io/demo/v1/cart'));
    final textContent = await response.readAsString();
    final List<CartProduct> products = (json.decode(textContent) as List)
        .map((json) => CartProduct.fromJson(json))
        .toList();

    return products;
  }
}
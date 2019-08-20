import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lzd_cart/bloc/cart/cart.dart';

import 'package:flutter_lzd_cart/ui/widgets/cart_bottom_bar.dart';
import 'package:flutter_lzd_cart/ui/widgets/cart_item.dart';
import 'package:flutter_lzd_cart/ui/widgets/custom_radio.dart';


class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoaded) {
              return Text(
                'My Cart (${state.products.length})',
                style: TextStyle(fontSize: 16.0),
              );
            }
            return Text(
              'My Cart',
              style: TextStyle(fontSize: 16.0),
            );
          },
        ),
        flexibleSpace: appBarBackground(),
        elevation: 0,
      ),
      backgroundColor: Color.fromRGBO(239, 240, 235, 1),
      body: BlocBuilder<CartBloc, CartState>(
        builder: buildContent,
      ),
      bottomNavigationBar: CartBottomBar(),
    );
  }

  Widget buildContent(context, CartState state) {
    if (state is CartLoading) {
      return CircularProgressIndicator();
    } else if (state is CartLoaded) {
      final cartBloc = BlocProvider.of<CartBloc>(context);
      final products = state.products;
      final selectedProducts = state.selectedProducts;

      return ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, int i) {
          return CartItem(
            radioState: selectedProducts.contains(products[i])
                ? RadioState.SELECTED
                : RadioState.NORMAL,
            product: products[i],
            onRadioClick: (product) {
              cartBloc.dispatch(ToggleSelectProduct(product));
            },
            onUpdateProduct: (product) {
              cartBloc.dispatch(UpdateProduct(product));
            },
          );
        },
      );
    } else if (state is CartError) {
      return Center(
        child: Text(state.exception.toString()),
      );
    }
    return Container();
  }

  Widget appBarBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromRGBO(255, 135, 99, 1),
          Color.fromRGBO(255, 51, 12, 1),
        ]),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_lzd_cart/bloc/cart/cart.dart';
import 'package:flutter_lzd_cart/repository/cart.dart';
import 'package:http_client/console.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lzd_cart/ui/screens/cart.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartBloc>(
      builder: (_) => CartBloc(repository: CartRepository(ConsoleClient())),
      child: MaterialApp(
        home: CartPage(),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http_client/console.dart';
import 'package:http_client/http_client.dart' as http;
import 'package:flutter_lzd_cart/view_models/cart_product.dart';
import 'package:flutter_lzd_cart/helpers/formatter.dart';
import 'package:flutter_lzd_cart/widgets/cart_item.dart';
import 'package:flutter_lzd_cart/widgets/custom_radio.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Cart(),
    );
  }
}

class Cart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CartState();
  }
}

class CartState extends State<Cart> {
  List<CartProduct> products = [];
  Set<CartProduct> selectedProducts = {};

  @override
  void initState() {
    super.initState();
    initProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'My Cart (${products.length})',
          style: TextStyle(fontSize: 16.0),
        ),
        flexibleSpace: appBarBackground(),
        elevation: 0,
      ),
      backgroundColor: Color.fromRGBO(239, 240, 235, 1),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, int i) {
          return CartItem(
            radioState: selectedProducts.contains(products[i])
                ? RadioState.SELECTED
                : RadioState.NORMAL,
            product: products[i],
            onRadioClick: handleRadioClick,
            onUpdateProduct: handleUpdateProduct,
          );
        },
      ),
      bottomNavigationBar: buildBottomBar(),
    );
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

  double get totalPrice {
    double result = 0.0;

    selectedProducts.forEach((p) {
      result += p.price * p.quantity;
    });

    return result;
  }

  bool get isCheckedAll {
    return selectedProducts.length == products.length;
  }

  Widget buildBottomBar() {
    final paddingBottom = MediaQuery.of(context).padding.bottom;

    return Material(
      elevation: 24.0,
      child: Container(
        padding: EdgeInsets.only(
            bottom: 7 + paddingBottom, left: 10, right: 10, top: 7),
        height: 57 + paddingBottom,
        child: Row(
          children: [
            FlatButton(
              child: Row(
                children: [
                  CustomRadio(
                    state:
                        isCheckedAll ? RadioState.SELECTED : RadioState.NORMAL,
                    onChange: handleCheckedAll,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text('All')
                ],
              ),
              onPressed: () {},
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(right: 15),
                alignment: Alignment.centerRight,
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(color: Color(0xff333333)),
                      children: [
                        TextSpan(
                            text: 'Total: ',
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.w500)),
                        TextSpan(
                            text: Formatter.formatCurrency(totalPrice),
                            style: TextStyle(
                                color: Color(0xffff330c),
                                fontWeight: FontWeight.bold))
                      ]),
                ),
              ),
            ),
            InkWell(
              child: Container(
                width: 155,
                height: 42,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(255, 51, 12, 0.3),
                          blurRadius: 10.0,
                          spreadRadius: 0.0,
                          offset: Offset(0.0, 6.0))
                    ],
                    borderRadius: BorderRadius.circular(6.0),
                    gradient: LinearGradient(colors: [
                      Color.fromRGBO(255, 135, 99, 1),
                      Color.fromRGBO(255, 51, 12, 1),
                    ])),
                alignment: Alignment.center,
                child: Text(
                  'Confirm Cart'.toUpperCase(),
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
              onTap: () {
                print('pressed');
              },
            )
          ],
        ),
        decoration: BoxDecoration(
          border:
              Border(top: BorderSide(color: Color.fromRGBO(230, 239, 245, 1))),
          color: Colors.white,
        ),
      ),
    );
  }

  void initProducts() async {
    final client = ConsoleClient();
    final response = await client.send(http.Request(
        'GET', 'https://5d58c6346bf39a0014c6d464.mockapi.io/demo/v1/cart'));
    final textContent = await response.readAsString();
    final List<CartProduct> products = (json.decode(textContent) as List)
        .map((json) => CartProduct.fromJson(json))
        .toList();
    setState(() {
      this.products = products;
    });
  }

  void handleRadioClick(CartProduct product) {
    setState(() {
      if (selectedProducts.contains(product)) {
        selectedProducts.remove(product);
      } else {
        selectedProducts.add(product);
      }
    });
  }

  void handleUpdateProduct(CartProduct product) {
    setState(() {
      int index = products.indexWhere((p) => p.id == product.id);
      products[index] = product;
      if (selectedProducts.contains(product)) {
        selectedProducts.removeWhere((p) => p.id == product.id);
        if (product.quantity != 0) {
          selectedProducts.add(product);
        }
      }
    });
  }

  void handleCheckedAll(RadioState newState) {
    setState(() {
      if (newState == RadioState.NORMAL) {
        selectedProducts.clear();
      } else {
        selectedProducts.addAll(products);
      }
    });

  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lzd_cart/bloc/cart/cart.dart';
import 'package:flutter_lzd_cart/ui/widgets/custom_radio.dart';
import 'package:flutter_lzd_cart/ui/widgets/confirm_button.dart';
import 'package:flutter_lzd_cart/helpers/formatter.dart';

class CartBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final paddingBottom = MediaQuery.of(context).padding.bottom;
    return Material(
      elevation: 24.0,
      child: Container(
        padding: EdgeInsets.only(
            bottom: 7, left: 10, right: 10, top: 7),
        height: 57,
        child: Row(
          children: [
            FlatButton(
              child: Row(
                children: [
                  BlocBuilder<CartBloc, CartState>(
                    builder: buildCheckbox,
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
                child: BlocBuilder<CartBloc, CartState>(
                  builder: buildTotalPrice,
                ),
              ),
            ),
            ConfirmButton(
              text: 'Confirm Cart'.toUpperCase(),
              onTap: () {
                print('confirmed');
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

  Widget buildCheckbox(context, CartState state) {
    CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
    if (state is CartLoaded) {
      final isCheckedAll = state.products.length == state.selectedProducts.length;
      return CustomRadio(
        state:
            isCheckedAll ? RadioState.SELECTED : RadioState.NORMAL,
        onChange: (_) {
          cartBloc.dispatch(ToggleSelectAllProducts());
        },
      );
    }
    if (state is CartLoading) {
      return CircularProgressIndicator();
    }
    return Container();
  }
  
  Widget buildTotalPrice(context, CartState state) {
    if (state is CartLoaded) {
      final products = state.selectedProducts;
      var totalPrice = 0.0;
      products.forEach((product) {
        totalPrice += product.price * product.quantity;
      });
      return RichText(
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
      );
    }
    if (state is CartLoading) {
      return CircularProgressIndicator();
    }
    return Container();
  }
}
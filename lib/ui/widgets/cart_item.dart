import 'package:flutter/material.dart';
import 'package:flutter_lzd_cart/ui/widgets/number_picker.dart';
import 'package:flutter_lzd_cart/helpers/formatter.dart';
import 'package:flutter_lzd_cart/ui/widgets/custom_radio.dart';
import 'package:flutter_lzd_cart/models/cart_product.dart';

typedef void RadioClickCallback(CartProduct product);
typedef void UpdateProductCallback(CartProduct product);

class CartItem extends StatelessWidget {
  final CartProduct product;
  final RadioState radioState;
  final UpdateProductCallback onUpdateProduct;
  final RadioClickCallback onRadioClick;
  const CartItem({this.product, this.radioState, this.onRadioClick, this.onUpdateProduct});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      margin: const EdgeInsets.only(bottom: 10.0),
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 13.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 0, right: 5),
                child: CustomRadio(
                  state: radioState,
                  onChange: (state) {
                    onRadioClick(product);
                  }
                ),
              ),
              Image.network(product.image, width: 96, height: 96),
              Expanded(
                child: buildProductInfo(),
              )
            ],
          ),
          if (product.tip != null)
            Padding(
              child: Text(
                product.tip,
              ),
              padding: const EdgeInsets.only(top: 10),
            ),
        ],
      ),
    );
  }

  Padding buildProductInfo() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            product.name,
            style:
                TextStyle(fontSize: 13, color: Color.fromRGBO(51, 51, 51, 1)),
          ),
          Text(
            '${product.brand}, ${product.attributes.map((attr) => attr.toString()).join(',')}',
            style: TextStyle(color: Color.fromRGBO(153, 153, 153, 1)),
          ),
          SizedBox(
            height: 13,
          ),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            direction: Axis.horizontal,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              buildPrice(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: NumberPicker(
                      value: product.quantity,
                      onChange: (newQuantity) {
                        onUpdateProduct(product.copyWith(quantity: newQuantity));
                      },
                    ),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildPrice() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Formatter.formatCurrency(product.price),
            style: TextStyle(
                fontSize: 12,
                color: Color.fromRGBO(255, 51, 12, 1),
                fontWeight: FontWeight.bold),
          ),
          if (product.salePrice != null)
            Row(
              children: [
                Text(
                  Formatter.formatCurrency(product.salePrice),
                  style: TextStyle(
                      fontSize: 12,
                      color: Color.fromRGBO(153, 153, 153, 1),
                      decoration: TextDecoration.lineThrough),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  '-${product.percentage}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromRGBO(153, 153, 153, 1),
                  ),
                )
              ],
            ),
        ],
      ), ],
    );
  }
}

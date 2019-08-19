class CartProduct {
  final String name;
  final String image;
  final String brand;
  final List<CartProductAttribute> attributes;
  final double price;
  final double salePrice;
  final int quantity;
  final String tip;
  final String id;

  CartProduct(
      {this.id,
      this.name,
      this.image,
      this.brand,
      this.attributes,
      this.price,
      this.salePrice,
      this.quantity,
      this.tip});

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return CartProduct(
      id: json['id'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      brand: json['brand'] as String,
      attributes: (json['attributes'] as List)
          .map((json) => CartProductAttribute.fromJson(json))
          .toList(),
      price: (json['price'] as num).toDouble(),
      salePrice: json['salePrice'] != null
          ? (json['salePrice'] as num).toDouble()
          : null,
      quantity: json['quantity'] as int,
      tip: json['tip'] != null ? json['tip'] as String : null,
    );
  }

  CartProduct copyWith(
      {int quantity,
      String name,
      String brand,
      List<CartProductAttribute> attributes,
      double price,
      double salePrice,
      String tip}) {
    return CartProduct(
      id: this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      brand: brand ?? this.brand,
      attributes: attributes ?? this.attributes,
      price: price ?? this.price,
      salePrice: salePrice ?? this.salePrice,
      quantity: quantity ?? this.quantity,
      tip: tip ?? this.tip,
    );
  }

  String toString() {
    return 'Product(name: $name, price: $price)';
  }

  int get percentage {
    if (salePrice != null) {
      return ((price / salePrice) * 100).round();
    }
    return null;
  }

  @override
  bool operator ==(Object p) {
    if (!(p is CartProduct)) {
      return false;
    }
    if (identical(this, p)) {
      return true;
    }
    return (p as CartProduct).id == this.id;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}

class CartProductAttribute {
  final String name;
  final String value;

  const CartProductAttribute({this.name, this.value});

  factory CartProductAttribute.fromJson(Map<String, dynamic> json) {
    return CartProductAttribute(
        name: json['name'] as String, value: json['value'] as String);
  }

  String toString() {
    return '$name: $value';
  }
}

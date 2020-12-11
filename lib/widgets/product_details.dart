import 'package:Shop_App/models/product.dart';
import 'package:flutter/material.dart';

class ProductDetail extends StatelessWidget {
  final Product product;

  ProductDetail(this.product);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../models/product.dart';

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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                product.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "\$${product.price}",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Text(
          product.description,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w100,
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: 10),
            alignment: Alignment.bottomCenter,
            child: FlatButton(
              child: Text(
                "ADD TO CART",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {},
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ],
    );
  }
}

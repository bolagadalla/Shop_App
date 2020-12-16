import 'package:flutter/material.dart';

import '../models/product.dart';
import '../widgets/product_detail.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const String routeName = "/product-details";
  @override
  Widget build(BuildContext context) {
    // Getting the argument passed when navigting to this screen
    final routeArg = ModalRoute.of(context).settings.arguments as Product;
    final Product _product = routeArg;

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(_product.title)),
        actions: [
          IconButton(
            icon: Icon(
              Icons.share,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: ProductDetail(_product),
    );
  }
}

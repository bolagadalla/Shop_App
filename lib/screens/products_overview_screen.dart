import 'package:flutter/material.dart';

import '../widgets/products_grid.dart';
import '../models/product.dart';

class ProductsOverviewScreen extends StatelessWidget {
  static String routeName = "/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Shop"),
      ),
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      body: ProductsGrid(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_detail.dart';
import '../providers/products_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const String routeName = "/product-details";
  @override
  Widget build(BuildContext context) {
    // Getting the argument passed when navigting to this screen
    final productID = ModalRoute.of(context).settings.arguments as String;
    // When the listen argument is set to false, it would not update when data changes in provider
    // This is helpful when we dont need to rebuild a widget rather we just want data only
    final loadedProduct = Provider.of<ProductsProvider>(context, listen: false)
        .findByID(productID);
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(loadedProduct.title)),
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
      body: ProductDetail(loadedProduct),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavorites;

  ProductsGrid(this.showFavorites);

  @override
  Widget build(BuildContext context) {
    // Only this widget will be rebuild when the data in the provider is changed
    // We are creating a direct communication with our provider
    final productsData = Provider.of<ProductsProvider>(context);
    final products = showFavorites
        ? productsData.favoriteProducts
        : productsData.getProducts;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        // Widgets in flutter are recycled so use value when you dont need to create a "NEW" build of the widget
        // But rather let flutter use the existing widget and recycle it but use the new data on the widget to rebuild it
        // So use .value and the value property whenever we are using an already existing object class
        // create: (ct) => products[index],
        value: products[index],
        child: ProductItem(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import '../providers/products_provider.dart';
import '../screens/edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const String routeName = "/user-product";

  @override
  Widget build(BuildContext context) {
    final productsDate = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productsDate.getProducts.length,
          itemBuilder: (_, index) => Column(
            children: [
              UserProductItem(
                title: productsDate.getProducts[index].title,
                imageURL: productsDate.getProducts[index].imageUrl,
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
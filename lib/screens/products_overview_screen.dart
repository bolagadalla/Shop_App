import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';

enum FilterOptions {
  Only_Favorites,
  Show_All,
}

class ProductsOverviewScreen extends StatefulWidget {
  static String routeName = "/";

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Shop"),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Only_Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: Text("Only Favorites"),
                  value: FilterOptions.Only_Favorites),
              PopupMenuItem(
                  child: Text("Show All"), value: FilterOptions.Show_All),
            ],
          ),
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(right: 4),
              child: Icon(
                Icons.search,
                size: 32,
              ),
            ),
            onTap: () {},
          ),
          Consumer<Cart>(
            // ch is the child of the Consumer
            // The child will not be rebuild, only the Badge
            builder: (ctx, cartData, ch) => Badge(
              child: ch,
              value: cartData.itemCount > 99
                  ? "99+"
                  : cartData.itemCount.toString(),
            ),
            // This will not be rebuild when the chart changes
            child: IconButton(
              icon: Icon(Icons.shopping_bag),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              splashRadius: 0.01,
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/product_details_screen.dart';
import './providers/products_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // it allows us to register a class where we can list for any data changes
    return ChangeNotifierProvider(
      // Must provide a new instance of the provider class
      // All child widgets on the tree can have access to this provider
      // Will only rebuild widgets that are listening
      create: (ctx) => ProductsProvider(),
      child: MaterialApp(
        title: 'Shop App',
        theme: ThemeData(
          primaryColor: Color.fromRGBO(40, 171, 185, 1),
          accentColor: Color.fromRGBO(45, 97, 135, 1),
          fontFamily: "Lato",
        ),
        // home: ProductsOverviewScreen(),
        routes: {
          ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
          ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
        },
      ),
    );
  }
}

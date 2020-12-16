import 'package:flutter/material.dart';

import '../models/product.dart';

// The ChangeNotifier is in charge of notifying listers when data has changed
// The lister must be at the highest point of the widget tree where you will start listening for new data
// Also so it can be passed down the tree
// In this case it must be the main.dart because we are using it int eh product_overview_screen.dart
class ProductsProvider with ChangeNotifier {
  List<Product> _products = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  // The reason why we use a getter to return the list is because
  // Everything is passed in by reference, which can change the original List
  // But using a getter will only give us the values rather then pointer reference
  List<Product> get products {
    return [..._products];
  }

  /// Adds a new product to the list
  void addProduct(Product product) {
    _products.add(product);
    // This is to be called at the end to notify listers that new data is avaliable
    // That also causes the widget that has the lister to rebuild itself
    notifyListeners();
  }
}

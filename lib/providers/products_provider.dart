import 'dart:convert';
import 'product.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exceptions.dart';

// The ChangeNotifier is in charge of notifying listers when data has changed
// The lister must be at the highest point of the widget tree where you will start listening for new data
// Also so it can be passed down the tree
// In this case it must be the main.dart because we are using it int eh product_overview_screen.dart
class ProductsProvider with ChangeNotifier {
  List<Product> _products = [
    // Product(
    //   id: 'p1',
    //   title: '',
    //   description: '',
    //   price: 29.99,
    //   imageUrl:
    //       '',
    // )

  ];

  List<Product> get favoriteProducts {
    return _products.where((element) => element.isFavorite).toList();
  }

  // The reason why we use a getter to return the list is because
  // Everything is passed in by reference, which can change the original List
  // But using a getter will only give us the values rather then pointer reference
  List<Product> get getProducts {
    return [..._products];
  }

  Product findByID(String id) {
    return _products.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    const url =
        "https://shop-app-f4370-default-rtdb.firebaseio.com/products.json";
    try {
      final response = await http.get(url);
      final extractedDate = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedDate.forEach(
        (prodID, prodData) {
          loadedProducts.add(
            Product(
              id: prodID,
              title: prodData["title"],
              description: prodData["description"],
              price: prodData["price"],
              imageUrl: prodData["imageUrl"],
              isFavorite: prodData["isFavorite"],
            ),
          );
        },
      );
      _products = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  /// Adds a new product to the list
  /// "async" will wrap our code and return it as a "Future" object
  /// Thats why we are not returning anything
  Future<void> addProduct(Product product) async {
    const url =
        "https://shop-app-f4370-default-rtdb.firebaseio.com/products.json";
    // try catch only works on syncrnous code
    // Since this is written like syncrnous code, we can use it here
    try {
      // Since http.post return a response, we store that into a variable
      final response = await http.post(
        url,
        body: json.encode(
          {
            "title": product.title,
            "description": product.description,
            "imageUrl": product.imageUrl,
            "price": product.price,
            "isFavorite": product.isFavorite,
          },
        ),
      );
      // This is put into an "invisible" ".then()" function
      final newProduct = Product(
        id: json.decode(response.body)["name"],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _products.add(newProduct);
      // This is to be called at the end to notify listers that new data is avaliable
      // That also causes the widget that has the lister to rebuild itself
      notifyListeners();
    } catch (error) {
      throw error;
    }
    // We throw this error here because we are handling errors in the "edit_product_screen.dart"
    // This just throws the error unto the upcoming "catchError" method
    // throw error;
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _products.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      final url =
          "https://shop-app-f4370-default-rtdb.firebaseio.com/products/$id.json";
      try {
        await http.patch(
          url,
          body: json.encode(
            {
              "title": newProduct.title,
              "description": newProduct.description,
              "imageUrl": newProduct.imageUrl,
              "price": newProduct.price,
            },
          ),
        );
        _products[productIndex] = newProduct;
        notifyListeners();
      } catch (error) {}
    } else
      print("...");
  }

  Future<void> deleteProduct(String id) async {
    final url =
        "https://shop-app-f4370-default-rtdb.firebaseio.com/products/$id.json";
    final existingProductIndex =
        _products.indexWhere((element) => element.id == id);
    Product existingProduct = _products[existingProductIndex];
    _products.removeAt(existingProductIndex);
    notifyListeners();
    // If we could not delete it, then we role back and put the product back into the list
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      // Role back if we could not delete it
      _products.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Could not delete product.");
    }
    existingProduct = null;
  }
}

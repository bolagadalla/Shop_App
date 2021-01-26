import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

// Needs the ChangeNotifier to be able to notify listeners
class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(
    String productID,
    double price,
    String title,
  ) {
    if (_items.containsKey(productID)) {
      _items.update(
        productID,
        (product) => CartItem(
          id: product.id,
          title: product.title,
          quantity: product.quantity + 1,
          price: product.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        productID,
        () => CartItem(
          id: productID,
          title: title,
          quantity: 1,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productID) {
    _items.remove(productID);
    notifyListeners();
  }

  void removeSingleItem(String productID) {
    if (!_items.containsKey(productID)) return;

    if (_items[productID].quantity > 1) {
      _items.update(
        productID,
        (cartItem) => CartItem(
          id: cartItem.id,
          title: cartItem.title,
          quantity: cartItem.quantity - 1,
          price: cartItem.price,
        ),
      );
    } else {
      _items.remove(productID);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}

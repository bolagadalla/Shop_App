import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  final String currentUserToken;
  Orders(this.currentUserToken, this._orders);

  List<OrderItem> get orders {
    return _orders;
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        "https://shop-app-f4370-default-rtdb.firebaseio.com/orders.json?auth=$currentUserToken";
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> loadedOrders = [];
      if (extractedData == null)
        return; // This would mean we dont have any thing in that database
      extractedData.forEach(
        (orderID, orderDate) {
          loadedOrders.add(
            OrderItem(
              id: orderID,
              amount: orderDate["amount"],
              dateTime: DateTime.parse(orderDate["dateTime"]),
              // This is a list within a map, so we access the element of the map, as List of dynamic objects
              // Thats so Dart doesnt give us an error.
              // With in that list we call map, where we will create a "CartItem" object for each object in the list from that map
              // Then we turn that map into a list
              products: (orderDate["products"] as List<dynamic>)
                  .map(
                    (e) => CartItem(
                      id: e["id"],
                      title: e["title"],
                      quantity: e["quantity"],
                      price: e["price"],
                    ),
                  )
                  .toList(),
            ),
          );
          _orders = loadedOrders.reversed.toList();
          notifyListeners();
        },
      );
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        "https://shop-app-f4370-default-rtdb.firebaseio.com/orders.json?auth=$currentUserToken";
    final timeStamp = DateTime.now();
    // try catch only works on syncrnous code
    // Since this is written like syncrnous code, we can use it here
    try {
      // Since http.post return a response, we store that into a variable
      final response = await http.post(
        url,
        body: json.encode(
          {
            "amount": total,
            "dateTime": timeStamp.toIso8601String(),
            "products": cartProducts
                .map(
                  (cp) => {
                    "id": cp.id,
                    "title": cp.title,
                    "quantity": cp.quantity,
                    "price": cp.price,
                  },
                )
                .toList(),
          },
        ),
      );
      // This will always add the latest order added to the first of the list
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)["name"],
          amount: total,
          products: cartProducts,
          dateTime: DateTime.now(),
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}

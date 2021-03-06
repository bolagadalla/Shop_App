import 'package:Shop_App/models/http_exceptions.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavorite(bool newStatus) {
    isFavorite = newStatus;
    notifyListeners();
  }

  // Toggle the favoirte property
  Future<void> toggleFavoriteStatus(
      String currentUserToken, String userID) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    // userFavorites folder/userID/productID
    // This means there will be a userFavorite folder which will contain all the userID
    // That marks a product as favorite (only). with in that userID folder
    // There will be all the products that they marked as favorite
    final url =
        "https://shop-app-f4370-default-rtdb.firebaseio.com/userFavorites/$userID/$id.json?auth=$currentUserToken";
    try {
      final response = await http.put(
        url,
        body: json.encode(
          {
            "isFavorite": isFavorite,
          },
        ),
      );
      if (response.statusCode >= 400) {
        _setFavorite(oldStatus);
        throw HttpException("There was an error updating product");
      }
    } catch (error) {
      _setFavorite(oldStatus);
    }
  }
}

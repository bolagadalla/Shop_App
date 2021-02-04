import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';
import '../screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  // Transition to the ProductDetailsScreen
  void _selectProduct(BuildContext context, String productID) {
    // The "then" keyward is what happens WHEN this screen has POPPED out of the screen view
    Navigator.of(context)
        .pushNamed(
      ProductDetailsScreen.routeName,
      arguments: productID,
    )
        .then((value) {
      if (value != null) print(value);
    });
  }

  /*
  When using Provider.of, it will always listen to changes and
  rebuild the WHOLE widget. However, Consumer also listen to changes
  of data, but only rebuild that part of the widget tree rather then the
  whole widget.
  */
  @override
  Widget build(BuildContext context) {
    // Not interested in listening to changes. ...listen: false
    final product = Provider.of<Product>(context, listen: false);
    // Gets the nearest provider which is in the main.dart
    final cart = Provider.of<Cart>(context, listen: false);
    // Get the user's token for the current logged in user
    final auth = Provider.of<Auth>(context, listen: false);

    var _theme = Theme.of(context);
    return GestureDetector(
      onTap: () => _selectProduct(context, product.id),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0.0, 15))
          ],
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Stack(
                children: [
                  Hero(
                    tag: product.id,
                    child: FadeInImage(
                      placeholder:
                          AssetImage("assets/images/product-placeholder.png"),
                      image: NetworkImage(product.imageUrl),
                      fit: BoxFit.cover,
                      height: 250,
                      width: double.infinity,
                    ),
                  ),
                  // The Add To Cart Button
                  Container(
                    height: 250,
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.all(5),
                    child: CircleAvatar(
                      radius: 30,
                      child: IconButton(
                        icon: Icon(
                          Icons.shopping_bag,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          cart.addItem(
                            product.id,
                            product.price,
                            product.title,
                          );
                          Scaffold.of(context).hideCurrentSnackBar();
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Added item to cart",
                                textAlign: TextAlign.center,
                              ),
                              duration: Duration(seconds: 2),
                              action: SnackBarAction(
                                label: "UNDO",
                                onPressed: () {
                                  cart.removeSingleItem(product.id);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      backgroundColor: _theme.accentColor,
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    // Will only rebuild the IconButton when data changes
                    child: Consumer<Product>(
                      builder: (ctx, product, child) => IconButton(
                        icon: Icon(
                          product.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                        ),
                        highlightColor: Color.fromARGB(0, 0, 0, 0),
                        splashColor: Color.fromARGB(0, 0, 0, 0),
                        onPressed: () {
                          product.toggleFavoriteStatus(auth.token, auth.userID);
                        },
                        color: Colors.red,
                        alignment: Alignment.topRight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.yellow[700],
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.yellow[700],
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.yellow[700],
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.yellow[700],
                  ),
                  Icon(
                    Icons.star_half,
                    color: Colors.yellow[700],
                  ),
                  Text(
                    "(10)",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
              child: FittedBox(
                child: SizedBox(
                  width: 190,
                  child: Text(
                    product.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
              child: FittedBox(
                child: Text(
                  "\$${product.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: _theme.primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

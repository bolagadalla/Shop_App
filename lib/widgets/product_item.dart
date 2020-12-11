import 'package:Shop_App/screens/product_details_screen.dart';

import '../models/product.dart';
import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem(this.product);

  // Transition to the ProductDetailsScreen
  void _selectMeal(BuildContext context) {
    // The "then" keyward is what happens WHEN this screen has POPPED out of the screen view
    Navigator.of(context)
        .pushNamed(
      ProductDetailsScreen.routeName,
      arguments: product,
    )
        .then((value) {
      if (value != null) print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    return GestureDetector(
      onTap: () => _selectMeal(context),
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
                  Image.network(
                    product.imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
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
                        onPressed: () {},
                      ),
                      backgroundColor: _theme.accentColor,
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(Icons.favorite),
                      onPressed: () {},
                      color: Colors.red,
                      alignment: Alignment.topRight,
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
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 0),
              child: Text(
                product.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 0),
              child: Text(
                "\$${product.price.toStringAsFixed(2)}",
                style: TextStyle(
                  color: _theme.primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

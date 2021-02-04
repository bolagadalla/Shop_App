import 'package:flutter/material.dart';

import '../providers/product.dart';

class ProductDetail extends StatelessWidget {
  final Product product;

  ProductDetail(this.product);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                child: Text(
                  product.title,
                  textAlign: TextAlign.center,
                ),
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
              ),
              background: Hero(
                tag: product.id,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "\$${product.price}",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w100,
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(
                  margin: EdgeInsets.only(top: 14),
                  alignment: Alignment.bottomCenter,
                  child: FlatButton(
                    child: Text(
                      "ADD TO CART",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {},
                    color: Theme.of(context).accentColor,
                  ),
                ),
                SizedBox(
                  height: 1000,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

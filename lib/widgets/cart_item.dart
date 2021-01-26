import 'package:Shop_App/providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productID;
  final double price;
  final String title;
  final int qty;

  CartItem({
    @required this.id,
    @required this.productID,
    @required this.price,
    @required this.title,
    @required this.qty,
  });

  @override
  Widget build(BuildContext context) {
    // Dismissible NEEDS a key, the key we used is the item id
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 10),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      // You get a direction to do different things based on the direction
      // confirmDismiss must return a Future
      confirmDismiss: (direction) {
        // showDialog returns a Future
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Are You Sure?"),
            content: Text("Do you want to remove the item from cart?"),
            actions: [
              FlatButton(
                onPressed: () {
                  // We can use Navigator.pop to control the type of Future we return.
                  // i.e. True or False
                  Navigator.of(ctx).pop(false);
                },
                child: Text("No"),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text("Yes"),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productID);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(
                child: Text(
                  "\$$price",
                ),
              ),
              radius: 30,
            ),
            title: Text(title),
            subtitle: Text("\$${qty * price}"),
            trailing: Text("$qty x"),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const String routeName = "/orders";

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // bool _isLoading = false;
  /// This approch is used when the build method needs to be rebuild
  /// while its SatelessWidget, because it will call "fetchAndSetOrder" everytime you
  /// reload the StatelessWidget and will cause unnesseccary web requests.
  /// This approch ensures there is no unnesseccary web requests made
  Future _ordersFuture;

  Future _obtainOrdersFuture() {
    // In the StatelessWidget approch, the line about Provider below is set in the "future" Property of FutureBuilder
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    // will be called after build is called, even tho its delayed by nothing
    // Future.delayed(Duration.zero).then((_) async {
    // _isLoading = true;
    // // Since we are not listening for update, then we can use this way of fetching and setting orders
    // Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then(
    //   (value) {
    //     setState(() {
    //       _isLoading = false;
    //     });
    //   },
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Since we are using a FutureBuilder then we use a "Consumer" instead of a provider
    // Otherwise it would go into an infinit loop where provider gets data, FutureBuilder rebuilds because of it
    // Then provider gets data again, and so on...
    // final orderData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              // Error Handling is done here
              return Center(
                child: Column(
                  children: [
                    Text(
                      "An error occurred while fetching orders",
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    FlatButton(
                      onPressed: () => {setState(() {})},
                      child: Text("Retry"),
                    ),
                  ],
                ),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, index) => OrderItem(
                    orderItem: orderData.orders[index],
                  ),
                ),
              );
            }
          }
        },
      ),
      drawer: AppDrawer(),
    );
  }
}

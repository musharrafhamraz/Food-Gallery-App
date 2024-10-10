import 'package:flutter/material.dart';
import 'package:tailorapp/firebase/order_services.dart';
import 'package:tailorapp/widgets/custom_button.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;
  final String itemName;
  final String quantity;
  final String price;

  const OrderDetailsScreen({
    required this.orderId,
    required this.itemName,
    required this.quantity,
    required this.price,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details: $itemName'),
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Item: $itemName',
            ),
            const SizedBox(height: 10),
            Text('Quantity: $quantity'),
            const SizedBox(height: 10),
            Text('Price: $price'),
            const Spacer(),
            CustomButton(
              onPress: () async {
                // Move order to progress tab
                await moveOrder(orderId, 'orders', 'progress');
                Navigator.pop(context);
              },
              buttonTxt: 'Accept Order',
            ),
          ],
        ),
      ),
    );
  }
}

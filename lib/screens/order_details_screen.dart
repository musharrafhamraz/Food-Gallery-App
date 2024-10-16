import 'package:flutter/material.dart';
import 'package:foodapp/firebase/order_services.dart';
import 'package:foodapp/widgets/background_widget.dart';
import 'package:foodapp/widgets/custom_button.dart';

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
      body: BackgroundWidget(
        backgroundImage: Padding(
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
                buttonTxt: const Text(
                  'Accept Order',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

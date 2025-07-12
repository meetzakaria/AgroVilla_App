import 'package:flutter/material.dart';
import 'buyer_home_screen.dart';

class CheckoutScreen extends StatelessWidget {
  final List<ProductModel> cartItems;

  const CheckoutScreen({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    double total = cartItems.fold(0, (sum, item) => sum + item.price);

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (_, index) {
                  final product = cartItems[index];
                  return ListTile(
                    title: Text(product.name),
                    trailing: Text("৳ ${product.price.toStringAsFixed(2)}"),
                  );
                },
              ),
            ),
            const Divider(),
            Text("Total: ৳ ${total.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("✅ Order Placed!")),
                );
              },
              child: const Text("Place Order", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'buyer_home_screen.dart';
import 'checkout_screen.dart'; // <-- Make sure to create this screen

class CartScreen extends StatefulWidget {
  final List<ProductModel> cart;
  const CartScreen({super.key, required this.cart});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<ProductModel> cartItems;

  @override
  void initState() {
    super.initState();
    cartItems = List.from(widget.cart);
  }

  void removeFromCart(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("❌ Removed from cart")),
    );
  }

  void returnUpdatedCart() {
    Navigator.pop(context, cartItems);
  }

  void goToCheckout() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CheckoutScreen(cartItems: cartItems)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        returnUpdatedCart(); // when back button pressed
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Your Cart"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: returnUpdatedCart,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: cartItems.isEmpty
                  ? const Center(child: Text("🛒 Your cart is empty"))
                  : ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (_, index) {
                  final product = cartItems[index];
                  return ListTile(
                    leading: Image.memory(
                      base64Decode(product.imageBase64),
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(product.name),
                    subtitle: Text("৳ ${product.price}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => removeFromCart(index),
                    ),
                  );
                },
              ),
            ),
            if (cartItems.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.green[800],
                    ),
                    onPressed: goToCheckout,
                    child: const Text(
                      "Proceed to Checkout",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

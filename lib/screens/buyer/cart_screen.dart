import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> cartItems = [
    {
      'name': 'Hybrid Tomato Seeds',
      'price': 120,
      'quantity': 1,
      'image': 'https://via.placeholder.com/150'
    },
    {
      'name': 'Organic Fertilizer',
      'price': 300,
      'quantity': 1,
      'image': 'https://via.placeholder.com/150'
    }
  ];

  double get totalPrice {
    return cartItems.fold(
        0,
            (sum, item) =>
        sum + (item['price'] as int) * (item['quantity'] as int));
  }

  void increaseQty(int index) {
    setState(() {
      cartItems[index]['quantity']++;
    });
  }

  void decreaseQty(int index) {
    setState(() {
      if (cartItems[index]['quantity'] > 1) {
        cartItems[index]['quantity']--;
      }
    });
  }

  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
        backgroundColor: Colors.green[800],
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text("🛒 Your cart is empty"))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: Image.network(item['image'], width: 50),
                    title: Text(item['name']),
                    subtitle:
                    Text("৳${item['price']} x ${item['quantity']}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () => decreaseQty(index),
                            icon: const Icon(Icons.remove)),
                        Text('${item['quantity']}'),
                        IconButton(
                            onPressed: () => increaseQty(index),
                            icon: const Icon(Icons.add)),
                        IconButton(
                            onPressed: () => removeItem(index),
                            icon: const Icon(Icons.delete_outline)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Total: ৳$totalPrice",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => const CartScreen()));
                  },
                  icon: const Icon(Icons.shopping_cart),
                )

              ],
            ),
          )
        ],
      ),
    );
  }
}


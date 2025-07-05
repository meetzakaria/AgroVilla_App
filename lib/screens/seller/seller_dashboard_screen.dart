import 'package:flutter/material.dart';

class SellerDashboardScreen extends StatelessWidget {
  const SellerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seller Dashboard"),
        backgroundColor: Colors.green[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                  labelText: 'Product Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                  labelText: 'Description', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: 'Price', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: 'Seeds',
              items: ['Seeds', 'Fertilizer', 'Equipment']
                  .map((cat) => DropdownMenuItem(
                  value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (val) {},
              decoration: const InputDecoration(
                  labelText: 'Category', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Submit Product API
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800]),
              child: const Text("Add Product"),
            )
          ],
        ),
      ),
    );
  }
}

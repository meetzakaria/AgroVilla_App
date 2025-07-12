import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'cart_screen.dart';

class ProductModel {
  final int id;
  final String name;
  final double price;
  final String imageBase64;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageBase64,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      imageBase64: json['image'],
    );
  }
}

class BuyerHomeScreen extends StatefulWidget {
  const BuyerHomeScreen({super.key});

  @override
  State<BuyerHomeScreen> createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends State<BuyerHomeScreen> {
  final List<String> featuredImages = [
    'assets/images/banner.jpg',
    'assets/images/banner2.jpg'
  ];

  final List<Map<String, String>> categories = [
    {'name': 'Seeds', 'icon': '🫘'},
    {'name': 'Fertilizers', 'icon': '🌾'},
    {'name': 'Equipment', 'icon': '🧰'},
    {'name': 'Machinery', 'icon': '🚜'},
    {'name': 'Saplings', 'icon': '🪴'},
    {'name': 'Fruits', 'icon': '🍇'},
  ];

  List<ProductModel> cart = [];

  Future<List<ProductModel>> fetchFeaturedProducts() async {
    final response = await http.get(Uri.parse('http://10.20.238.45:8081/api/products/all'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  void addToCart(ProductModel product) {
    setState(() {
      cart.add(product);
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Product added to cart')));
  }

  void goToCartScreen() async {
    final updatedCart = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CartScreen(cart: cart)),
    );

    if (updatedCart != null && updatedCart is List<ProductModel>) {
      setState(() {
        cart = updatedCart;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F9F9),
      appBar: AppBar(
        title: Text("AgroVilla", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green.shade600,
        centerTitle: true,
        actions: [
          IconButton(onPressed: goToCartScreen, icon: const Icon(Icons.shopping_cart)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            const SizedBox(height: 10),
            _buildBanner(featuredImages),
            const SizedBox(height: 20),
            Text("Categories", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            _buildCategoryList(),
            const SizedBox(height: 20),
            Text("Featured Products", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            _buildFeaturedProductsFuture(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: "Search keywords..",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildBanner(List<String> images) {
    return CarouselSlider(
      options: CarouselOptions(height: 160.0, autoPlay: true, enlargeCenterPage: true),
      items: images.map((i) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.green.shade100),
          child: Image.asset(i, fit: BoxFit.cover),
        );
      }).toList(),
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (_, index) {
          return GestureDetector(
            onTap: () {
              // Later implement CategoryProductScreen
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(8),
              width: 80,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 2, blurRadius: 5),
              ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(categories[index]['icon']!, style: const TextStyle(fontSize: 28)),
                  const SizedBox(height: 4),
                  Text(categories[index]['name']!, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedProductsFuture() {
    return FutureBuilder<List<ProductModel>>(
      future: fetchFeaturedProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }

        final products = snapshot.data ?? [];
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 3 / 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: products.map((product) {
            return Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 2, blurRadius: 5),
              ]),
              child: Column(
                children: [
                  Expanded(
                    child: Image.memory(base64Decode(product.imageBase64), fit: BoxFit.cover),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        children: [
                        Text(product.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    Text("৳ ${product.price}", style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 4),
                    ElevatedButton(
                      onPressed: () => addToCart(product),
                      child: const Text("Add to Cart"),
                      )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

// 🛒 Cart Screen


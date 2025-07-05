import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';

class BuyerHomeScreen extends StatelessWidget {
  final List<String> featuredImages = [
    'assets/images/banner.jpg',
    'assets/images/banner2.jpg'
  ];

  final List<Map<String, String>> categories = [
    {'name': 'Vegetables', 'icon': '🥦'},
    {'name': 'Grocery', 'icon': '🛒'},
    {'name': 'Beverages', 'icon': '🥤'},
    {'name': 'Dairy', 'icon': '🧀'},
    {'name': 'Meat', 'icon': '🍖'},
    {'name': 'Fruits', 'icon': '🍎'},
  ];

  final List<Map<String, String>> featuredProducts = [
    {'name': 'Fresh Peach', 'price': '\৳ 32.50', 'image': 'assets/images/peach.jpg'},
    {'name': 'Avocado', 'price': '\৳ 22.20', 'image': 'assets/images/avocado.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      appBar: AppBar(
        title: Text("AgroVilla", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green.shade600,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            SizedBox(height: 10),
            _buildBanner(featuredImages),
            SizedBox(height: 20),
            Text("Categories", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: 10),
            _buildCategoryList(categories),
            SizedBox(height: 20),
            Text("Featured Products", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: 10),
            _buildFeaturedProducts(featuredProducts),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
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
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.green.shade100),
              child: Image.asset(i, fit: BoxFit.cover),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildCategoryList(List<Map<String, String>> categories) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (_, index) {
          return Container(
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
          );
        },
      ),
    );
  }

  Widget _buildFeaturedProducts(List<Map<String, String>> products) {
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
              Expanded(child: Image.asset(product['image']!, fit: BoxFit.contain)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(product['name']!, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    Text(product['price']!, style: const TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

import 'dart:io';
import 'package:agrovilla/screens/seller/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SellerDashboardScreen extends StatefulWidget {
  const SellerDashboardScreen({super.key});

  @override
  State<SellerDashboardScreen> createState() => _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends State<SellerDashboardScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  String selectedCategory = 'Seeds';

  File? _selectedImage;
  bool isLoading = false;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  Future<void> addProduct() async {
    final name = nameController.text.trim();
    final desc = descriptionController.text.trim();
    final price = priceController.text.trim();
    final qty = quantityController.text.trim();

    if (name.isEmpty || desc.isEmpty || price.isEmpty || qty.isEmpty || _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields including image are required.")),
      );
      return;
    }

    setState(() => isLoading = true);

    const url = "http://10.20.238.45:8081/api/products/add";

    try {
      final mimeType = lookupMimeType(_selectedImage!.path) ?? 'image/jpeg';
      final imageMultipart = await http.MultipartFile.fromPath(
        'image', // Must match ProductForm.getImage()
        _selectedImage!.path,
        contentType: MediaType.parse(mimeType),
      );

      final request = http.MultipartRequest('POST', Uri.parse(url))
        ..fields['name'] = name
        ..fields['description'] = desc
        ..fields['price'] = price
        ..fields['quantity'] = qty
        ..fields['category'] = selectedCategory
        ..files.add(imageMultipart);

      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Product added successfully!")),
        );
        nameController.clear();
        descriptionController.clear();
        priceController.clear();
        quantityController.clear();
        setState(() {
          _selectedImage = null;
        });
      } else {
        debugPrint("❌ Server Error: $responseBody");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Failed: ${streamedResponse.statusCode}")),
        );
      }
    } catch (e) {
      debugPrint("❌ Exception: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Something went wrong!")),
      );
    }

    setState(() => isLoading = false);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushReplacementNamed(context, '/buyerHome');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seller Dashboard"),
        backgroundColor: Colors.green[800],
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductScreen()),
              );
            },
            icon: const Icon(Icons.production_quantity_limits_sharp),
          ),
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
          )
        ],

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Product Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: ['Seeds', 'Fertilizer', 'Equipment']
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (val) => setState(() => selectedCategory = val!),
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: pickImage,
                  child: const Text("Choose Image"),
                ),
                const SizedBox(width: 12),
                _selectedImage != null
                    ? Image.file(_selectedImage!, width: 60, height: 60)
                    : const Text("No image selected")
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : addProduct,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green[800]),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Add Product", style: TextStyle(color: Colors.black)),
            )
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/Model/Product.dart';
import 'package:task/Screens/ProductList.dart';

class AddProductPage extends StatefulWidget {
  final VoidCallback onProductAdded;

  const AddProductPage({Key? key, required this.onProductAdded}) : super(key: key);

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Product Price'),
            ),
            SizedBox(height: 20.0),
            _image != null
                ? Image.file(
              _image!,
              height: 100,
            )
                : Container(),
            ElevatedButton(
              onPressed: () {
                _pickImage();
              },
              child: Text('Select Image'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _addProduct();
              },
              child: Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _addProduct() async {
    String name = nameController.text;
    String priceText = priceController.text;

    // Validate form
    if (name.isEmpty || priceText.isEmpty) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields'),
        ),
      );
      return;
    }

    double price = double.tryParse(priceText) ?? 0.0;
    // Save image to local storage (optional)
    String imagePath = "";
    if (_image != null) {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String path = directory.path;
      final String fileName = 'product_image_${DateTime.now().millisecondsSinceEpoch}.png';
      final File imageFile = File('$path/$fileName');
      await imageFile.writeAsBytes(await _image!.readAsBytes());
      imagePath = imageFile.path;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? productList = prefs.getStringList('products') ?? [];

    productList.add(json.encode(Product(name: name, price: price, imagePath: imagePath).toJson()));
    prefs.setStringList('products', productList);

    // Notify the parent widget that a new product is added
    widget.onProductAdded();

    // Navigate back to home page
    Navigator.pop(context);
  }

}

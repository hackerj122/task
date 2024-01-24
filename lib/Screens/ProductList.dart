import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/Model/Product.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {

  late List<Product> products;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }
  @override
  Widget build(BuildContext context) {
    _loadProducts();
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (query) {
              _searchProducts(query);
            },
            decoration: InputDecoration(
              labelText: 'Search',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        Expanded(
          child: products.isNotEmpty
              ? ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(products[index].name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('\$${products[index].price}'),
                    products[index].imagePath.isNotEmpty
                        ? Image.file(
                      File(products[index].imagePath),
                      height: 100,
                      width: 100,
                    )
                        : Container(),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteProduct(index);
                  },
                ),
              );
            },
          )
              : Center(
            child: Text('No Product Found'),
          ),
        ),
      ],
    );
  }

  void _loadProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? productList = prefs.getStringList('products');

    if (productList != null) {
      setState(() {
        products = productList.map((jsonString) {
          return Product.fromJson(json.decode(jsonString));
        }).toList();
      });
    } else {
      setState(() {
        products = [];
      });
    }
  }

  void _deleteProduct(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // widget.onProductDeleted(index);
    setState(() {
      products.removeAt(index);
    });
    List<String> productStrings =
    products.map((product) => json.encode(product.toJson())).toList();
    prefs.setStringList('products', productStrings);
  }

  void _searchProducts(String query) {
    // Filter products based on search query
    List<Product> filteredProducts = products
        .where((product) =>
        product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      products = filteredProducts;
    });
  }

  void reloadProducts() {
    _loadProducts();
  }
}
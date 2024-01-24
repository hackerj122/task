import 'package:flutter/material.dart';
import 'package:task/Screens/AddProductPage.dart';
import 'package:task/Screens/ProductList.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: ProductList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProductPage(onProductAdded: () {  },),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

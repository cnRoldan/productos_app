import 'package:flutter/material.dart';
import 'package:productos_app/widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
      ),
      body: ListView.builder(
        itemCount: 10, 
        itemBuilder: (BuildContext context, int index) => GestureDetector(
          child: const ProductCard(),
          onTap: () => Navigator.pushNamed(context, 'product'),
          
          )),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}

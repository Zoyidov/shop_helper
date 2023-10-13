
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shop_helper/utils/icons.dart';
import '../../data/local/db.dart';
import '../../data/model/product_model.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final productDatabase = ProductDatabase();
    await productDatabase.initialize();
    final productList = await productDatabase.getAllProducts();

    final filteredProducts =
        productList.where((product) => product.number! > 0).toList();

    setState(() {
      products = filteredProducts;
    });
  }

  Future<void> _deleteProduct(String barcode) async {
    final productDatabase = ProductDatabase();
    await productDatabase.initialize();
    await productDatabase.deleteProduct(barcode);

    await _loadProducts();
  }

  Widget _buildProductList() {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(AppImages.empty),
            const Text(
              'No products yet.',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Dismissible(
          key: Key(product.barcode),
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              _deleteProduct(product.barcode);
            }
          },
          secondaryBackground: Container(
            margin: const EdgeInsets.symmetric(vertical: 10,),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.red),
            alignment: Alignment.centerRight,
            child: const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ),
          background: Container(
            color: Colors.transparent,
            alignment: Alignment.centerRight,
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10,),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),color: Colors.white,
              boxShadow: [
              BoxShadow(
              color: Colors.black38,
              offset: Offset(0, 2),
              blurRadius: 10,
              spreadRadius: 1,
              )],
            ),
            child: ListTile(
              title: Text(
                '${product.name}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                'QR: ${product.barcode}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: Text('Count: ${product.number}'),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Lottie.asset(
              AppImages.background,
              fit: BoxFit.fill
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: _buildProductList(),
        )]),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../data/local/db.dart';
import '../../data/model/product_model.dart';

class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  late QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String scannedData = '';
  late ProductDatabase productDatabase;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
    productDatabase = ProductDatabase();
    productDatabase.initialize();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      _initializeCamera();
    } else {}
  }

  void _initializeCamera() {
    setState(() {
      scannedData = '';
    });
  }

  bool isFlashOn = false;

  void toggleFlashlight() {
    setState(() {
      isFlashOn = !isFlashOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Text(
          'Scan QR Code',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () async{
              await controller.toggleFlash();
              toggleFlashlight();
            },
            icon: isFlashOn
                ? Icon(Icons.flashlight_on,color: Colors.white,)
                : Icon(Icons.flashlight_off,color: Colors.white,),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.white,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
              ),
              onQRViewCreated: (controller) {
                this.controller = controller;
                controller.scannedDataStream.listen((scanData) {
                  setState(() {
                    scannedData = scanData.code!;
                  });
                });
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (scannedData.isNotEmpty)
                  ? Text(
                      'Scanned Data: $scannedData',
                      style: TextStyle(color: Colors.white),
                    )
                  : Text(''),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 100.0),
            child: Center(
              child: ZoomTapAnimation(
                onTap: () {
                  _showAddProductDialog(context);
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white),
                  child: Icon(Icons.touch_app),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _showAddProductDialog(BuildContext context) async {
    final TextEditingController countController = TextEditingController();
    final String barcode = scannedData.split(':')[0];

    final existingProducts = await productDatabase.getAllProducts();
    Product? existingProduct;
    for (var product in existingProducts) {
      if (product.barcode == barcode) {
        existingProduct = product;
        break;
      }
    }

    if (existingProduct != null) {
      // ignore: use_build_context_synchronously
      showDialog(
        barrierColor: Colors.black,
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text("You can update the quantity of the product"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: countController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Product Count"),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (countController.text.isNotEmpty) {
                    int count = int.tryParse(countController.text) ?? 0;
                    if (existingProduct != null) {
                      existingProduct.number =
                          (existingProduct.number ?? 0) + count;
                      await productDatabase.updateProduct(existingProduct);
                    }
                  }
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text(
                  "Update Count",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          );
        },
      );
    } else {
      final TextEditingController nameController = TextEditingController();
      showDialog(
        barrierColor: Colors.black,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("New Product"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: "Product Name"),
                ),
                TextField(
                  controller: countController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(labelText: "Product Count"),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (nameController.text.isNotEmpty &&
                      countController.text.isNotEmpty) {
                    int count = int.tryParse(countController.text) ?? 0;
                    String productName = nameController.text;
                    _saveProductWithDetails(barcode, productName, count);
                  }
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text(
                  "Add Product",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  void _saveProductWithDetails(String barcode, String name, int count) async {
    final product = Product(barcode: barcode, number: count, name: name);
    await productDatabase.insertProduct(product);

    setState(() {
      scannedData = 'Product saved: $barcode, $count, $name';
    });
  }
}

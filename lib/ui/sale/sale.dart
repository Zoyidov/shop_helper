import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../data/local/db.dart';
import '../../data/model/product_model.dart';

class SaleScreen extends StatefulWidget {
  @override
  _SaleScreenState createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
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
                  ? Text('Scanned Data: $scannedData',style: TextStyle(color: Colors.white),)
                  : Text(''),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 100.0),
            child: Center(
              child: ZoomTapAnimation(
                onTap: () {
                  _showSaleProductDialog(context);
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

  void _showSaleProductDialog(BuildContext context) async {
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
            title: Text("The number of products being sold"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: countController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Count"),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
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
                      existingProduct.number = (existingProduct.number ?? 0) - count;
                      await productDatabase.updateProduct(existingProduct);
                    }
                  }
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text(
                  "Sold",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          );
        },
      );
    } else {
      AwesomeDialog(
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.error,
        body: Center(
          child: Text(
            'Product not Found',
          ),
        ),
        title: 'This is Ignored',
        desc: 'This is also Ignored',
        btnOkOnPress: () {},
      ).show();
    }
  }
}

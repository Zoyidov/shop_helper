import 'package:flutter/material.dart';
import 'package:shop_helper/ui/add_product/add_product.dart';
import 'package:shop_helper/ui/products/products.dart';
import 'package:shop_helper/ui/sale/sale.dart';
import 'package:shop_helper/utils/icons.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Stack(
        children: [
          Container(
           height: MediaQuery.of(context).size.height,
           width: MediaQuery.of(context).size.width,
            child: Lottie.asset(
              AppImages.background,
              fit: BoxFit.fill
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ZoomTapAnimation(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => QRScannerScreen()));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.black38),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Add Product", style: TextStyle(color: Colors.white)),
                          Icon(Icons.add_circle, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  ZoomTapAnimation(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SaleScreen()));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.black38),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Sale Product", style: TextStyle(color: Colors.white)),
                          Icon(Icons.shopping_cart_rounded, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  ZoomTapAnimation(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProductListScreen()));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.black38),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Report", style: TextStyle(color: Colors.white)),
                          Icon(Icons.data_usage_sharp, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

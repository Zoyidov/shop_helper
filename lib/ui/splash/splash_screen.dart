// ignore_for_file: use_build_context_synchronously
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shop_helper/ui/home/home_screen.dart';
import '../../utils/icons.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      _navigateToHomeScreen(context);
    });

    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Center(
        child: Lottie.asset(AppImages.splash,fit: BoxFit.fill),
      ),
    );
  }
  void _navigateToHomeScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (context)=>HomeScreen())
    );
  }
}

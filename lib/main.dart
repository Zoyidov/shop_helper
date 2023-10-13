import 'package:flutter/material.dart';
import 'package:shop_helper/ui/splash/splash_screen.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shop_helper/data/bloc/bloc.dart';
// import 'package:shop_helper/data/local/db.dart';
// import 'package:shop_helper/ui/splash/splash_screen.dart';
//
// void main() {
//   ProductDatabase();
//   runApp(const App());
// }
//
// class App extends StatelessWidget {
//   const App({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(providers: [
//       BlocProvider(create: (context) => ProductBloc()),
//     ], child: const MyApp());
//   }
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: SplashScreen(),
//     );
//   }
// }

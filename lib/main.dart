import 'package:flutter/material.dart';
import 'package:my_shop/screens/product_detail_screen.dart';
import 'package:my_shop/screens/products_overview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
            .copyWith(secondary: Colors.deepOrange),
        fontFamily: "Lato",
      ),
      home: ProductOverviewScreen(),
      routes: {
        ProductDetailScreen.routeName: (context) => const ProductDetailScreen(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:my_shop/screens/cart_screen.dart';
import 'package:my_shop/widgets/appbar_badge.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../widgets/products_grid.dart';

enum FilterOptions { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({super.key});

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Shop"),
        actions: [
          Consumer<Cart>(
            builder: (_, cart, child) => AppBarBadge(
              value: cart.itemCount.toString(),
              child: child!,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: FilterOptions.Favorites,
                child: Text("Only Favorite"),
              ),
              const PopupMenuItem(
                value: FilterOptions.All,
                child: Text("Show All"),
              ),
            ],
          )
        ],
      ),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}

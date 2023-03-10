import 'package:flutter/material.dart';
import 'package:my_shop/providers/products_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFav;
  const ProductsGrid(this.showFav, {super.key});

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductsProvider>(context);
    final products = showFav ? productData.favoritesOnly : productData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 3 / 2,
      ),
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
          // create: (context) => products[index],
          value: products[index],
          child: const ProductItem(
              // products[index].id,
              // products[index].title,
              // products[index].imageUrl,
              ),
        );
      },
    );
  }
}

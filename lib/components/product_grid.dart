import 'package:PBStore/components/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/product_list.dart';
import 'items/product_grid_item.dart';

class ProductView extends StatelessWidget {
  final bool showFavoriteOnly;

  const ProductView({super.key, required this.showFavoriteOnly});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      small: ProductGrid(
        showFavoriteOnly: showFavoriteOnly,
        crossAxisCount: 1,
        childAspectRatio: 1.5,
      ),
      medium: ProductGrid(
        showFavoriteOnly: showFavoriteOnly,
        crossAxisCount: 2,
        childAspectRatio: 1,
      ),
      large: ProductGrid(
        showFavoriteOnly: showFavoriteOnly,
        crossAxisCount: 4,
        childAspectRatio: 1,
      ),
      xlarge: ProductGrid(
        showFavoriteOnly: showFavoriteOnly,
        crossAxisCount: 5,
        childAspectRatio: 1,
      ),
    );
  }
}

class ProductGrid extends StatelessWidget {
  final bool showFavoriteOnly;

  final int crossAxisCount;
  final double childAspectRatio;

  const ProductGrid(
      {super.key,
      required this.showFavoriteOnly,
      required this.crossAxisCount,
      required this.childAspectRatio});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
    final List<Product> loadedProducts =
        showFavoriteOnly ? provider.favoriteItems : provider.items;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      itemCount: loadedProducts.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: loadedProducts[i],
        child: const ProductGridItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}

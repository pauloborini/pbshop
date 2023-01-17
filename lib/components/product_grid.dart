import 'package:PBStore/components/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/product_repository.dart';
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

class ProductGrid extends StatefulWidget {
  final bool showFavoriteOnly;

  final int crossAxisCount;
  final double childAspectRatio;

  const ProductGrid(
      {super.key,
      required this.showFavoriteOnly,
      required this.crossAxisCount,
      required this.childAspectRatio});

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  ValueNotifier<bool> loaded = ValueNotifier(false);

  @override
  void initState() {
    Provider.of<ProductRepository>(context, listen: false).loadProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    loaded.value = false;
    final productRep = Provider.of<ProductRepository>(context);
    final List<Product> loadedProducts =
        widget.showFavoriteOnly ? productRep.favoriteItems : productRep.items;
    loaded.value = true;

    return ValueListenableBuilder(
        valueListenable: loaded,
        builder: (context, bool isLoaded, child) {
          return (isLoaded && loadedProducts.isNotEmpty)
              ? GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(10),
                  itemCount: loadedProducts.length,
                  itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                    value: loadedProducts[i],
                    child: const ProductGridItem(),
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: widget.crossAxisCount,
                    childAspectRatio: widget.childAspectRatio,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
        });
  }
}

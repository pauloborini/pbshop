import 'package:PBStore/providers/product_list.dart';
import 'package:PBStore/utils/colors_and_vars.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../utils/app_routes.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);

    return Stack(children: [
      Container(
        decoration: BoxDecoration(
            color: stanColor, borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    width: 100,
                    height: 30,
                    child: FittedBox(
                      child: Text(
                        product.name,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    )),
                Consumer<ProductList>(
                  builder: (ctx, productList, _) => IconButton(
                    onPressed: () {
                      productList.toggleFavorite(product);
                    },
                    icon: Icon(product.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRoutes.productDetail,
            arguments: product,
          );
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.175,
          decoration: (BoxDecoration(
              color: stanColor,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12), topLeft: Radius.circular(12)),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    product.imageUrl,
                  )))),
        ),
      ),
    ]);
  }
}

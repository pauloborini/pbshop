import 'package:PBStore/pages/product_detail_page.dart';
import 'package:PBStore/providers/product_list.dart';
import 'package:PBStore/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../utils/app_routes.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProductDetailPage(
                  product: product,
                )));
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
        alignment: Alignment.bottomCenter,
        height: MediaQuery.of(context).size.height * 0.2,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  product.imageUrl,
                ))),
        child: Container(
          decoration: BoxDecoration(
            color: stanColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
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
                      style: const TextStyle(fontSize: 18, color: Colors.black),
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
          ),
        ),
      ),
    );
  }
}

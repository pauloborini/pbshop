import 'package:PBStore/providers/product_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../components/badge.dart';
import '../models/product.dart';
import '../providers/cart.dart';
import '../utils/app_routes.dart';
import '../utils/colors_and_vars.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providerCart = Provider.of<Cart>(context, listen: false);
    final providerProductList = Provider.of<ProductList>(context);
    final Product product =
        ModalRoute.of(context)!.settings.arguments as Product;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.home, (route) => false);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          product.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          Consumer<Cart>(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.cart);
              },
              icon: const Icon(
                FontAwesomeIcons.cartShopping,
                size: 26,
              ),
            ),
            builder: (ctx, cart, child) => Badge(
              value: cart.itemsCount.toString(),
              child: child!,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24))),
            height: 300,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24)),
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                width: MediaQuery.of(context).size.width,
                height: 110,
                decoration: BoxDecoration(
                    color: stanColor.withOpacity(0.8),
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(24),
                        bottomLeft: Radius.circular(24))),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Text(
                        product.description,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 120, 0),
                          child: Text(
                            'R\$ ${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: IconButton(
                            onPressed: () {
                              providerProductList.toggleFavorite(product);
                            },
                            icon: Icon(
                              product.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 28,
                            ),
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            FontAwesomeIcons.cartShopping,
                            size: 23,
                          ),
                          color: Theme.of(context).colorScheme.secondary,
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                    'Produto adicionado com sucesso!'),
                                duration: const Duration(seconds: 2),
                                action: SnackBarAction(
                                  label: 'DESFAZER',
                                  onPressed: () {
                                    providerCart.removeSingleItem(product.id);
                                  },
                                ),
                              ),
                            );
                            providerCart.addItem(product);
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

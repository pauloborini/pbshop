import 'package:PBStore/components/responsive.dart';
import 'package:PBStore/providers/product_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../components/badge.dart';
import '../models/product.dart';
import '../providers/cart.dart';
import '../utils/app_routes.dart';
import '../utils/constants.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    final providerCart = Provider.of<Cart>(context, listen: false);
    final providerProductList = Provider.of<ProductList>(context);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    if (widget.product == null) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
    return Responsive.isXTest(context)
        ? const Scaffold()
        : Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, AppRoutes.home, (route) => false);
                },
                icon: const Icon(Icons.arrow_back),
              ),
              title: Text(
                widget.product.name,
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
            body: Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    constraints: const BoxConstraints(maxWidth: maxWidth),
                    width: width * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    height: height * 0.7,
                    child: Responsive.isTest(context)
                        ? Center(
                            child: Column(
                              children: [
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        widget.product.imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: width * 0.7,
                                        child: Text(
                                          widget.product.description,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 22),
                                          maxLines: 4,
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        child: Text(
                                          'R\$ ${widget.product.price.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            FittedBox(
                                              child: IconButton(
                                                onPressed: () {
                                                  providerProductList
                                                      .toggleFavorite(widget.product);
                                                },
                                                icon: Icon(
                                                  widget.product.isFavorite
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  size: 28,
                                                ),
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                            ),
                                            FittedBox(
                                              child: IconButton(
                                                icon: const Icon(
                                                  FontAwesomeIcons.cartShopping,
                                                  size: 23,
                                                ),
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                onPressed: () {
                                                  ScaffoldMessenger.of(context)
                                                      .hideCurrentSnackBar();
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: const Text(
                                                          'Produto adicionado com sucesso!'),
                                                      duration:
                                                          const Duration(seconds: 2),
                                                      action: SnackBarAction(
                                                        label: 'DESFAZER',
                                                        onPressed: () {
                                                          providerCart.removeSingleItem(
                                                              widget.product.id);
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                  providerCart.addItem(widget.product);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        : Row(children: [
                            const SizedBox(width: defaultPadding),
                            Container(
                              decoration:
                                  BoxDecoration(borderRadius: BorderRadius.circular(12)),
                              height: height * 0.5,
                              width: width * 0.35,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  widget.product.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: defaultPadding),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: width * 0.2,
                                  height: height * 0.1,
                                  child: Text(
                                    'R\$ ${widget.product.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.2,
                                  height: height * 0.2,
                                  child: Text(
                                    widget.product.description,
                                    style: const TextStyle(fontSize: 22),
                                    maxLines: 4,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.2,
                                  height: height * 0.1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      FittedBox(
                                        child: IconButton(
                                          onPressed: () {
                                            providerProductList
                                                .toggleFavorite(widget.product);
                                          },
                                          icon: Icon(
                                            widget.product.isFavorite
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            size: 28,
                                          ),
                                          color: Theme.of(context).colorScheme.secondary,
                                        ),
                                      ),
                                      FittedBox(
                                        child: IconButton(
                                          icon: const Icon(
                                            FontAwesomeIcons.cartShopping,
                                            size: 23,
                                          ),
                                          color: Theme.of(context).colorScheme.secondary,
                                          onPressed: () {
                                            ScaffoldMessenger.of(context)
                                                .hideCurrentSnackBar();
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: const Text(
                                                    'Produto adicionado com sucesso!'),
                                                duration: const Duration(seconds: 2),
                                                action: SnackBarAction(
                                                  label: 'DESFAZER',
                                                  onPressed: () {
                                                    providerCart.removeSingleItem(
                                                        widget.product.id);
                                                  },
                                                ),
                                              ),
                                            );
                                            providerCart.addItem(widget.product);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ]),
                  )
                ],
              ),
            ),
          );
  }
}

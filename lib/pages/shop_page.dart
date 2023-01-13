import 'package:PBStore/components/responsive.dart';
import 'package:PBStore/utils/constants.dart';
import 'package:dyn_mouse_scroll/dyn_mouse_scroll.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../components/app_drawer.dart';
import '../components/badge.dart';
import '../components/product_grid.dart';
import '../providers/cart.dart';
import '../utils/app_routes.dart';

enum FilterOptions {
  favorite,
  all,
}

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  bool _showFavoriteOnly = false;

  @override
  Widget build(BuildContext context) {
    return Responsive.isXTest(context)
        ? const Scaffold()
        : Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              title: const Text('PB Store'),
              actions: [
                PopupMenuButton(
                  icon: const Icon(
                    Icons.more_vert,
                    size: 30,
                  ),
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: FilterOptions.favorite,
                      child: Text('Somente Favoritos'),
                    ),
                    const PopupMenuItem(
                      value: FilterOptions.all,
                      child: Text('Todos'),
                    ),
                  ],
                  onSelected: (FilterOptions selectedValue) {
                    setState(() {
                      if (selectedValue == FilterOptions.favorite) {
                        _showFavoriteOnly = true;
                      } else {
                        _showFavoriteOnly = false;
                      }
                    });
                  },
                ),
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
            body: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  children: [
                    Expanded(
                      child: DynMouseScroll(
                        builder: (context, controller, physics) => SingleChildScrollView(
                          controller: controller,
                          physics: physics,
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text('As Melhores ofertas da Internet',
                                    style: TextStyle(fontSize: 24)),
                              ),
                              ProductView(
                                showFavoriteOnly: _showFavoriteOnly,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            drawer: const AppDrawer(),
          );
  }
}

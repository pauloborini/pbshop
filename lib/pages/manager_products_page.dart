import 'package:PBStore/components/responsive.dart';
import 'package:PBStore/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../components/app_drawer.dart';
import '../components/items/manager_product_item.dart';
import '../providers/product_repository.dart';

class ManagerProductsPage extends StatelessWidget {
  const ManagerProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsRep = Provider.of<ProductRepository>(context);
    return Responsive.isXTest(context)
        ? const Scaffold()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Gerenciar Produtos'),
            ),
            drawer: const AppDrawer(),
            body: RefreshIndicator(
              onRefresh: () async {
                await productsRep.loadProducts();
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: productsRep.itemsCount,
                  itemBuilder: (context, index) => Column(
                    children: [
                      ManagerProductItem(product: productsRep.items[index]),
                      const Divider(),
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.newproduct);
                },
                backgroundColor: Theme.of(context).colorScheme.secondary,
                child: const Icon(FontAwesomeIcons.plus)),
          );
  }
}

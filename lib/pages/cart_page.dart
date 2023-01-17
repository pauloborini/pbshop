import 'package:PBStore/components/responsive.dart';
import 'package:PBStore/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/items/cart_item.dart';
import '../providers/cart.dart';
import '../providers/order_list.dart';
import '../utils/app_routes.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of(context);
    final items = cart.items.values.toList();

    return Responsive.isXTest(context)
        ? const Scaffold()
        : Scaffold(
            appBar: AppBar(
              title: const Text(
                'Carrinho de Compras',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, AppRoutes.home, (route) => false);
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            body: Column(
              children: [
                SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.68,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (ctx, i) => CartItemWidget(items[i]),
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                if (cart.itemsCount > 0) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Finalizar pedido?'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: const Text(
                                  'Não',
                                  style: TextStyle(fontSize: 20),
                                )),
                            TextButton(
                                onPressed: () {
                                  Provider.of<OrderList>(
                                    context,
                                    listen: false,
                                  ).addOrder(cart);
                                  cart.clear();
                                  Navigator.of(context).pop(true);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Pedido criado com sucesso'),
                                    duration: Duration(seconds: 2),
                                  ));
                                },
                                child: const Text(
                                  'Sim',
                                  style: TextStyle(fontSize: 20),
                                )),
                          ],
                        );
                      });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Adicione algum item para realizar o Pedido'),
                      duration: Duration(seconds: 2)));
                }
              },
              backgroundColor: stanColor,
              shape: const StadiumBorder(),
              label: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  const SizedBox(
                    width: padding / 2,
                  ),
                  Chip(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    label: Text(
                      'R\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: padding * 2,
                  ),
                  const Text(
                    'COMPRAR',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
                  ),
                ],
              ),
            ),
          );
  }
}

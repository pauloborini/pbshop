import 'package:PBStore/providers/product_repository.dart';
import 'package:PBStore/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';

class ManagerProductItem extends StatelessWidget {
  final Product product;

  const ManagerProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final productRep = Provider.of<ProductRepository>(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.name),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.editproduct, arguments: product);
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.black,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Deletar o item?'),
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
                              onPressed: () async {
                                await productRep
                                    .removeProduct(product)
                                    .catchError((onError) {
                                  return showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Erro ao '
                                              'Excluir'),
                                          content:
                                              const Text('Tente novamente mais tarde'),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('OK'))
                                          ],
                                        );
                                      });
                                }).then((value) {
                                  Navigator.of(context).pop(true);
                                });
                              },
                              child: const Text(
                                'Sim',
                                style: TextStyle(fontSize: 20),
                              )),
                        ],
                      );
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}

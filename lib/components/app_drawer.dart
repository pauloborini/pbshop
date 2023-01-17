import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Drawer(
        child: Column(
          children: [
            const AspectRatio(
              aspectRatio: 2,
              child: Center(
                  child: Text(
                'Bem vindo a PB Store!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26),
                maxLines: 2,
              )),
            ),
            const Divider(
              thickness: 1,
            ),
            ListTile(
              leading: const Icon(FontAwesomeIcons.store),
              title: const Text('Loja', style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(
                  AppRoutes.home,
                );
              },
            ),
            const Divider(
              thickness: 1,
            ),
            ListTile(
              leading: const Icon(FontAwesomeIcons.creditCard),
              title: const Text('Pedidos', style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(
                  AppRoutes.orders,
                );
              },
            ),
            const Divider(
              thickness: 1,
            ),
            ListTile(
              leading: const Icon(FontAwesomeIcons.pen),
              title: const Text('Gerenciar Produtos', style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(
                  AppRoutes.products,
                );
              },
            ),
            const Divider(
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}

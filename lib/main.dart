import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/cart_page.dart';
import 'pages/edit_product_page.dart';
import 'pages/manager_products_page.dart';
import 'pages/new_product_form_page.dart';
import 'pages/orders_page.dart';
import 'pages/product_detail_page.dart';
import 'pages/shop_page.dart';
import 'providers/cart.dart';
import 'providers/order_list.dart';
import 'providers/product_list.dart';
import 'utils/app_routes.dart';
import 'utils/functions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductList()),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (_) => OrderList()),
      ],
      child: MaterialApp(
        scrollBehavior: MyCustomScrollBehavior(),
        title: 'Flutter Demo',
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: Colors.redAccent,
              secondary: Colors.deepOrange,
            ),
            fontFamily: 'Login',
            appBarTheme: const AppBarTheme(
                elevation: 0,
                scrolledUnderElevation: 0,
                titleTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.black))),
        initialRoute: AppRoutes.home,
        routes: {
          AppRoutes.home: (ctx) => const ShopPage(),
          AppRoutes.productDetail: (ctx) => const ProductDetailPage(),
          AppRoutes.cart: (ctx) => const CartPage(),
          AppRoutes.orders: (ctx) => const OrdersPage(),
          AppRoutes.products: (ctx) => const ManagerProductsPage(),
          AppRoutes.newproduct: (ctx) => const NewProductFormPage(),
          AppRoutes.editproduct: (ctx) => const EditProductPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

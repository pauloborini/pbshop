import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../data/dummy_data.dart';
import '../models/product.dart';

class ProductList with ChangeNotifier {
  final _urlFirebase = 'https://pbstore-sample-default-rtdb.firebaseio.com/';
  final List<Product> _items = dummyProducts;

  List<Product> get items => [..._items];

  List<Product> get favoriteItems => _items.where((prod) => prod.isFavorite).toList();

  int get itemsCount {
    return _items.length;
  }

  void addProduct(Product product) {
    http.post(Uri.parse('$_urlFirebase/products.json'),
        body: jsonEncode({
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
          "isFavorite": product.isFavorite,
        }));
    _items.add(product);
    notifyListeners();
  }

  void removeProduct(Product product) {
    _items.remove(product);
    notifyListeners();
  }

  void saveProduct(
      TextEditingController nameController,
      TextEditingController descController,
      TextEditingController priceController,
      TextEditingController urlController) {
    final product = Product(
        id: Random().nextDouble().toString(),
        name: nameController.text,
        description: descController.text,
        price: double.parse(priceController.text),
        imageUrl: urlController.text);
    addProduct(product);
    notifyListeners();
  }

  void updateProduct(
      TextEditingController nameController,
      TextEditingController descController,
      TextEditingController priceController,
      TextEditingController urlController,
      Product product) {
    int index = _items.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      final product = Product(
          id: index.toString(),
          name: nameController.text,
          description: descController.text,
          price: double.parse(priceController.text),
          imageUrl: urlController.text);
      _items[index] = product;
      notifyListeners();
    }
  }

  void toggleFavorite(Product product) {
    product.isFavorite = !product.isFavorite;
    notifyListeners();
  }
}

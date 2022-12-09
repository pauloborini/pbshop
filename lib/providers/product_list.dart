import 'dart:math';

import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../models/product.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = dummyProducts;

  List<Product> get items => [..._items];

  List<Product> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();

  int get itemsCount {
    return _items.length;
  }

  void addProduct(Product product) {
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

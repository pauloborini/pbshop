import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductList with ChangeNotifier {
  final _urlFirebase = 'https://pbstore-sample-default-rtdb.firebaseio.com/products.json';
  final List<Product> _items = [];

  List<Product> get items => [..._items];

  List<Product> get favoriteItems => _items.where((prod) => prod.isFavorite).toList();

  int get itemsCount {
    return _items.length;
  }

  ProductList() {
    loadProducts();
  }

  loadProducts() async {
    final response = await http.get(Uri.parse(_urlFirebase));
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((productID, productData) {
      _items.add(Product(
        id: productID,
        name: productData["name"],
        description: productData["description"],
        price: productData["price"],
        imageUrl: productData["imageUrl"],
        isFavorite: productData["isFavorite"],
      ));
    });
    notifyListeners();
  }

  addProduct(Product product) async {
    final response = await http.post(Uri.parse(_urlFirebase),
        body: jsonEncode({
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
          "isFavorite": product.isFavorite,
        }));

    final id = jsonDecode(response.body)["name"];
    _items.add(Product(
        id: id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        isFavorite: product.isFavorite));
    notifyListeners();
  }

  void removeProduct(Product product) {
    _items.remove(product);
    notifyListeners();
  }

  Future<void> saveProduct(
      TextEditingController nameController,
      TextEditingController descController,
      TextEditingController priceController,
      TextEditingController urlController) async {
    final product = Product(
        id: 'id',
        name: nameController.text,
        description: descController.text,
        price: double.parse(priceController.text),
        imageUrl: urlController.text);
    await addProduct(product);
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

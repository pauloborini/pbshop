import 'dart:convert';
import 'package:PBStore/exceptions/http_exception.dart';
import 'package:PBStore/models/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductRepository with ChangeNotifier {
  final _baseURL = 'https://pbstore-sample-default-rtdb.firebaseio.com/products';
  final List<Product> _items = [];

  List<Product> get items => [..._items];

  List<Product> get favoriteItems => _items.where((prod) => prod.isFavorite).toList();

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadProducts() async {
    _items.clear();
    final response = await http.get(Uri.parse('$_baseURL.json'));
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

  Future<void> addProduct(Product product) async {
    final response = await http.post(Uri.parse('$_baseURL.json'),
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

  Future<void> removeProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      final response = await http.delete(Uri.parse('$_baseURL/${product.id}.json'));
      notifyListeners();
      loadProducts();
      if (response.statusCode >= 400) {
        throw HTTPException(
            message: 'Não foi possível Excluir o Produto',
            statusCode: response.statusCode);
      }
    }
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

  Future<void> updateProduct(
      TextEditingController nameController,
      TextEditingController descController,
      TextEditingController priceController,
      TextEditingController urlController,
      Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      await http.patch(Uri.parse('$_baseURL/${product.id}.json'),
          body: jsonEncode({
            "name": nameController.text,
            "description": descController.text,
            "price": double.parse(priceController.text),
            "imageUrl": urlController.text,
          }));
      notifyListeners();
      loadProducts();
    }
  }

  Future<void> toggleFavorite(Product product) async {
    product.isFavorite = !product.isFavorite;
    notifyListeners();
    int index = _items.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      await http.patch(Uri.parse('$_baseURL/${product.id}.json'),
          body: jsonEncode({"isFavorite": product.isFavorite}));
      notifyListeners();
    }
  }
}

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance =
      DatabaseHelper._privateConstructor();

  static const String _productsKey = 'inventory_products';

  // ============================================================
  // GET SHARED PREFERENCES
  // ============================================================

  Future<SharedPreferences> get _prefs async {
    return await SharedPreferences.getInstance();
  }

  // ============================================================
  // GET ALL PRODUCTS
  // ============================================================

  Future<List<Product>> getProducts() async {
    final prefs = await _prefs;

    final String? jsonData = prefs.getString(_productsKey);

    if (jsonData == null || jsonData.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decoded = jsonDecode(jsonData);

      return decoded
          .map(
            (item) => Product.fromMap(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  // ============================================================
  // GET ALL PRODUCTS - ALIAS
  // ============================================================

  Future<List<Product>> getAllProducts() async {
    return await getProducts();
  }

  // ============================================================
  // SAVE PRODUCTS
  // ============================================================

  Future<void> _saveProducts(List<Product> products) async {
    final prefs = await _prefs;

    final List<Map<String, dynamic>> data = products
        .map((product) => product.toMap())
        .toList();

    await prefs.setString(
      _productsKey,
      jsonEncode(data),
    );
  }

  // ============================================================
  // ADD PRODUCT
  // ============================================================

  Future<int> addProduct(Product product) async {
    final products = await getProducts();

    int newId = 1;

    if (products.isNotEmpty) {
      final ids = products
          .map((product) => product.id ?? 0)
          .toList();

      newId = ids.reduce(
            (a, b) => a > b ? a : b,
          ) +
          1;
    }

    final newProduct = product.copyWith(
      id: newId,
    );

    products.add(newProduct);

    await _saveProducts(products);

    return newId;
  }

  // ============================================================
  // INSERT PRODUCT
  // ============================================================

  // This is kept because your Add Product screen may call
  // insertProduct() instead of addProduct().

  Future<int> insertProduct(Product product) async {
    return await addProduct(product);
  }

  // ============================================================
  // UPDATE PRODUCT
  // ============================================================

  Future<int> updateProduct(
    Product product, [
    int? oldId,
  ]) async {
    final products = await getProducts();

    final int targetId = oldId ?? product.id ?? -1;

    final int index = products.indexWhere(
      (item) => item.id == targetId,
    );

    if (index == -1) {
      return 0;
    }

    final updatedProduct = product.copyWith(
      id: targetId,
    );

    products[index] = updatedProduct;

    await _saveProducts(products);

    return 1;
  }

  // ============================================================
  // DELETE PRODUCT
  // ============================================================

  Future<int> deleteProduct(int id) async {
    final products = await getProducts();

    final int oldLength = products.length;

    products.removeWhere(
      (product) => product.id == id,
    );

    if (products.length == oldLength) {
      return 0;
    }

    await _saveProducts(products);

    return 1;
  }

  // ============================================================
  // TOTAL PRODUCTS
  // ============================================================

  Future<int> getTotalProducts() async {
    final products = await getProducts();

    return products.length;
  }

  // ============================================================
  // TOTAL STOCK
  // ============================================================

  Future<int> getTotalStock() async {
    final products = await getProducts();

    int total = 0;

    for (final product in products) {
      total += product.quantity;
    }

    return total;
  }

  // ============================================================
  // LOW STOCK
  // ============================================================

  Future<int> getLowStockCount() async {
    final products = await getProducts();

    int count = 0;

    for (final product in products) {
      if (product.quantity <= 10) {
        count++;
      }
    }

    return count;
  }

  // ============================================================
  // INVENTORY VALUE
  // ============================================================

  Future<double> getInventoryValue() async {
    final products = await getProducts();

    double total = 0.0;

    for (final product in products) {
      total += product.quantity * product.price;
    }

    return total;
  }

  // ============================================================
  // SEARCH
  // ============================================================

  Future<List<Product>> searchProducts(
    String query,
  ) async {
    final products = await getProducts();

    if (query.trim().isEmpty) {
      return products;
    }

    final searchText = query.toLowerCase().trim();

    return products.where((product) {
      return product.name
              .toLowerCase()
              .contains(searchText) ||
          product.category
              .toLowerCase()
              .contains(searchText);
    }).toList();
  }

  // ============================================================
  // CATEGORY
  // ============================================================

  Future<List<Product>> getProductsByCategory(
    String category,
  ) async {
    final products = await getProducts();

    return products.where((product) {
      return product.category.toLowerCase() ==
          category.toLowerCase();
    }).toList();
  }

  // ============================================================
  // CLEAR DATABASE
  // ============================================================

  Future<void> clearProducts() async {
    final prefs = await _prefs;

    await prefs.remove(_productsKey);
  }
}
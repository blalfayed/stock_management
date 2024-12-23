import 'package:flutter/material.dart';

import '../data/database_helper.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> get products => _products;

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> loadProducts() async {
    _products = await _dbHelper.fetchProducts();
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    await _dbHelper.insertProduct(product);
    await loadProducts();
  }

  Future<void> updateProduct(Product product) async {
    await _dbHelper.updateProduct(product);
    await loadProducts();
  }

  Future<void> deleteProduct(int id) async {
    await _dbHelper.deleteProduct(id);
    await loadProducts();
  }

  // Fetch low stock products
  Future<List<Product>> fetchLowStockProducts(int threshold) async {
    return await _dbHelper.fetchLowStockProducts(threshold);
  }

  // Fetch expired products
  Future<List<Product>> fetchExpiredProducts(String currentDate) async {
    return await _dbHelper.fetchExpiredProducts(currentDate);
  }

  // Fetch total stock
  Future<int> fetchTotalStock() async {
    return await _dbHelper.fetchTotalStock();
  }

  // Search products
  Future<void> searchProducts(String keyword) async {
    _products = await _dbHelper.searchProducts(keyword);
    notifyListeners();
  }
}

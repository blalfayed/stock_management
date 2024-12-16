// Database Helper
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/product.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('stock_management.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const productTable = '''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        price REAL NOT NULL,
        location TEXT NOT NULL,
        expiryDate TEXT NOT NULL
      );
    ''';
    await db.execute(productTable);
  }

  Future<int> insertProduct(Product product) async {
    final db = await instance.database;
    return await db.insert('products', product.toMap());
  }

  Future<List<Product>> fetchProducts() async {
    final db = await instance.database;
    final maps = await db.query('products');

    return maps.map((map) => Product.fromMap(map)).toList();
  }

  Future<int> updateProduct(Product product) async {
    final db = await instance.database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await instance.database;
    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Fetch products with low stock
  Future<List<Product>> fetchLowStockProducts(int threshold) async {
    final db = await instance.database;
    final maps = await db.query(
      'products',
      where: 'quantity < ?',
      whereArgs: [threshold],
    );
    return maps.map((map) => Product.fromMap(map)).toList();
  }

  // Fetch expired products
  Future<List<Product>> fetchExpiredProducts(String currentDate) async {
    final db = await instance.database;
    final maps = await db.query(
      'products',
      where: 'expiryDate < ?',
      whereArgs: [currentDate],
    );
    return maps.map((map) => Product.fromMap(map)).toList();
  }

  // Fetch total stock
  Future<int> fetchTotalStock() async {
    final db = await instance.database;
    final result =
        await db.rawQuery('SELECT SUM(quantity) AS total FROM products');
    return result.first['total'] as int;
  }

  // Search products
  Future<List<Product>> searchProducts(String keyword) async {
    final db = await instance.database;
    final maps = await db.query(
      'products',
      where: 'name LIKE ? OR location LIKE ?',
      whereArgs: ['%$keyword%', '%$keyword%'],
    );
    return maps.map((map) => Product.fromMap(map)).toList();
  }
}

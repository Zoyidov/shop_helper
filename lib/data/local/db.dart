import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/product_model.dart';

class ProductDatabase {
  late Database _database;

  Future<void> initialize() async {
    final path = join(await getDatabasesPath(), 'product_database.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE products(
            barcode TEXT,
            number INTEGER,
            name TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertProduct(Product product) async {
    await _database.insert('products', product.toMap());
  }

  Future<List<Product>> getAllProducts() async {
    final List<Map<String, dynamic>> maps = await _database.query('products');
    return List.generate(maps.length, (index) {
      return Product(
          barcode: maps[index]['barcode'],
          number: maps[index]['number'],
          name: maps[index]['name']);
    });
  }

  Future<void> updateProduct(Product product) async {
    await _database.update(
      'products',
      product.toMap(),
      where: 'barcode = ?',
      whereArgs: [product.barcode],
    );
  }

  Future<void> deleteProduct(String barcode) async {
    await _database.delete(
      'products',
      where: 'barcode = ?',
      whereArgs: [barcode],
    );
  }
}

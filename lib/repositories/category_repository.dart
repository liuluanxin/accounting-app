import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../database/tables.dart';
import '../models/category.dart';

class CategoryRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Category>> getByType(String type) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      Tables.categories,
      where: '${Tables.catType} = ?',
      whereArgs: [type],
      orderBy: '${Tables.catSortOrder} ASC',
    );
    return maps.map(_fromDbMap).toList();
  }

  Future<List<Category>> getAll() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      Tables.categories,
      orderBy: '${Tables.catSortOrder} ASC',
    );
    return maps.map(_fromDbMap).toList();
  }

  Future<Category?> getById(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      Tables.categories,
      where: '${Tables.catId} = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return _fromDbMap(maps.first);
  }

  Category _fromDbMap(Map<String, dynamic> map) {
    return Category(
      id: map[Tables.catId] as String,
      name: map[Tables.catName] as String,
      icon: map[Tables.catIcon] as String?,
      type: map[Tables.catType] as String,
      sortOrder: (map[Tables.catSortOrder] as num).toInt(),
    );
  }
}

import 'package:recipe_hub/tables/User_Table.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqfliteDatabase {
  static Database? db;

  // Initialize the database
  static Future<void> initialize() async {
    if (db == null) {
      String path = await _getDbPath();
      db = await openDatabase(path, onCreate: _onCreate, version: 1);
    }
  }

  // Create tables when the database is created
  static Future<void> _onCreate(Database db, int version) async {
    await db.execute(UserTable.create);

    print('Database created and tables initialized');
  }

  // Get the database path
  static Future<String> _getDbPath() async {
    String databasePath = await getDatabasesPath();
    return join(databasePath, 'recipe.db'); // Consistent database name
  }

  // Delete the entire database
  static Future<void> deleteDb() async {
    String path = await _getDbPath();
    await deleteDatabase(path);
  }

  // Method to get the database instance safely
  static Future<Database> getDb() async {
    if (db == null) {
      await initialize();
    }
    return db!;
  }
}

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = join(directory.path, 'calculator_app.db');

      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {

          await db.execute('''
            CREATE TABLE calculations (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              calculation TEXT NOT NULL,
              timestamp TEXT NOT NULL
            )
          ''');
        },
      );
    } catch (e) {
      print('Error opening database: $e');
      rethrow;
    }
  }

  Future<void> saveCalculation(String calculation, String timestamp) async {
    try {
      final db = await database;
      await db.insert('calculations', {
        'calculation': calculation,
        'timestamp': timestamp,
      });
    } catch (e) {
      print('Error saving calculation: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    try {
      final db = await database;
      return await db.query(
        'calculations',
        orderBy: 'id DESC',
      );
    } catch (e) {
      print('Error getting history: $e');
      rethrow;
    }
  }
}

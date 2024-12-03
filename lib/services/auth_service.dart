import 'package:sqflite/sqflite.dart';
import 'database_service.dart';

class AuthService {
  final DatabaseService _databaseService = DatabaseService();
  final DatabaseService databaseService = DatabaseService();


  Future<void> register(String username, String password) async {
    final db = await _databaseService.database;
    try {
      print("User registration: $username");
      await db.insert('users', {
        'username': username,
        'password': password,
      });
      print("User successfully registrated");
    } catch (e) {
      print("Registration error: $e");
      throw Exception('This login already taken or something');
    }
  }

  Future<bool> deleteAccount(String username, String password) async {
    try {
      final db = await DatabaseService().database;

      final result = await db.query(
        'users',
        where: 'username = ? AND password = ?',
        whereArgs: [username, password],
      );

      if (result.isEmpty) {
        return false;
      }

      int deleteCount = await db.delete(
        'users',
        where: 'username = ? AND password = ?',
        whereArgs: [username, password],
      );

      return deleteCount > 0;
    } catch (e) {
      print('Error deleting account: $e');
      return false;
    }
  }

  Future<int?> login(String username, String password) async {
    final db = await _databaseService.database;

    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      return result.first['id'] as int;
    } else {
      return null;
    }
  }
}

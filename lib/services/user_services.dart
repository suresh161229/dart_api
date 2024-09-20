import 'package:dart_api/models/user_model.dart';
import '../db/db_connection.dart';

class UserService {
  final DBConnection _dbConnection = DBConnection();

  Future<List<User>> getAll() async {
    final conn = await _dbConnection.connect();
    final results = await conn.query('SELECT id, name FROM users');
    return results.map((row) => User.fromMap(row.fields)).toList();
  }

  Future<User> create(String name, String company) async {
    try {
      print("Attempting to connect to the database..."); // Debug print
      final conn = await _dbConnection.connect();
      print("Connected to the database: $conn"); // Debug print

      // print('Inserting user: name=$name, company=$company');
      // print(name);
      // print(company);

      // final result = await conn.query('INSERT INTO users (name, company) VALUES ($name, $company);');
      final query = 'INSERT INTO users (name, company) VALUES (?, ?)';
      print('Executing query: $query with values: $name, $company');
      final result = await conn.query(query, ['asfaa', 'spnelta']);
      print("Query executed, result: $result");

      final insertId = result.insertId;
      print("Inserted ID: $insertId"); // Debug print

      return User(id: insertId, name: name, company: company);
    } catch (e) {
      print('Database connection or query failed: $e'); // Ensure this prints if there's an error
      rethrow;
    }
  }

  Future<int> update(int id, String name, String company) async {
    final conn = await _dbConnection.connect();
    final result = await conn.query(
      'UPDATE users SET name = ?, company = ? WHERE id = ?',
      [name, company, id],
    );
    return result.affectedRows!;
  }

  Future<int> deleteItem(int id) async {
    final conn = await _dbConnection.connect();
    final result = await conn.query(
      'DELETE FROM users WHERE id = ?',
      [id],
    );
    return result.affectedRows!;
  }
}

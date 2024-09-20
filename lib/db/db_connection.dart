import 'package:dart_mysql/dart_mysql.dart';

class DBConnection {
  static final DBConnection _instance = DBConnection._internal();
  MySqlConnection? _connection;

  DBConnection._internal();

  factory DBConnection() {
    return _instance;
  }

  Future<MySqlConnection> connect() async {
    print('connection ${_connection}');
    if (_connection == null) {
      final settings = ConnectionSettings(
        host: 'localhost',
        port: 3306,
        user: 'root',
        password: 'root',
        db: 'my_database',
      );
      _connection = await MySqlConnection.connect(settings);
    }
    return _connection!;
  }

  Future<void> close() async {
    await _connection?.close();
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

void main() async {
  // Create an in-memory list of users
  final users = <Map<String, dynamic>>[];

  // Define routes
  final router = Router();

  // GET /users - Get all users
  router.get('/users', (Request request) {
    final jsonResponse = jsonEncode({'users': users});
    return Response.ok(jsonResponse, headers: {'Content-Type': 'application/json'});
  });

  // POST /users - Create a new user
  router.post('/user', (Request request) async {
    final payload = await request.readAsString();
    final Map<String, dynamic> user = jsonDecode(payload);
    user['id'] = users.length + 1;
    users.add(user);
    return Response.ok(jsonEncode(user), headers: {'Content-Type': 'application/json'});
  });

  // PUT /users/<id> - Update an existing user
  router.put('/users/<id>', (Request request, String id) async {
    final int userId = int.parse(id);
    final payload = await request.readAsString();
    final updateduser = jsonDecode(payload) as Map<String, dynamic>;
    final index = users.indexWhere((user) => user['id'] == userId);
    if (index == -1) {
      return Response.notFound('user not found');
    }
    users[index] = updateduser..['id'] = userId;
    return Response.ok(jsonEncode(updateduser), headers: {'Content-Type': 'application/json'});
  });

  // DELETE /users/<id> - Delete an user
  router.delete('/users/<id>', (Request request, String id) {
    final int userId = int.parse(id);
    final index = users.indexWhere((user) => user['id'] == userId);
    if (index == -1) {
      return Response.notFound('user not found');
    }
    final removeduser = users.removeAt(index);
    return Response.ok(jsonEncode(removeduser), headers: {'Content-Type': 'application/json'});
  });

  // Start the server
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(router);
  final server = await io.serve(handler, 'localhost', 8080);
  print('Server running on http://${server.address.host}:${server.port}');
}

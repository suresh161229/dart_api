import 'dart:convert';
import 'package:dart_api/services/user_services.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class UserRoutes {
  final UserService _userService = UserService();

  Router get router {
    final router = Router();

    // GET /items - Get all users
    router.get('/users', (Request request) async {
      final users = await _userService.getAll();
      final jsonResponse = jsonEncode({'users': users.map((item) => item.toMap()).toList()});
      return Response.ok(jsonResponse, headers: {'Content-Type': 'application/json'});
    });

    // POST /items - Create a new user
    router.post('/user', (Request request) async {
      final payload = await request.readAsString();
      print('payload :$payload');
      final data = jsonDecode(payload);
      print('data datatype :${data['name']}');
      final newUser = await _userService.create(data['name'], data['company']);
      print('userData :$newUser');
      return Response.ok(jsonEncode(newUser), headers: {'Content-Type': 'application/json'});
    });

    // PUT /items/<id> - Update an existing user
    router.put('/users/<id>', (Request request, String id) async {
      final int itemId = int.parse(id);
      final payload = await request.readAsString();
      final Map<String, dynamic> data = jsonDecode(payload);
      final affectedRows = await _userService.update(itemId, data['name'], data['company']);
      if (affectedRows == 0) {
        return Response.notFound('route not found');
      }
      return Response.ok(jsonEncode({'id': itemId, 'name': data['name']}), headers: {'Content-Type': 'application/json'});
    });

    // DELETE /items/<id> - Delete an user
    router.delete('/users/<id>', (Request request, String id) async {
      final int itemId = int.parse(id);
      final affectedRows = await _userService.deleteItem(itemId);
      if (affectedRows == 0) {
        return Response.notFound('Item not found');
      }
      return Response.ok(jsonEncode({'id': itemId}), headers: {'Content-Type': 'application/json'});
    });

    return router;
  }
}

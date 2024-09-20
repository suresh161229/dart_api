import 'dart:convert';
import 'package:dart_api/routes/user_routes.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

// Define your User and UserService classes as before

void main() async {
  final router = Router();
  final userRoutes = UserRoutes();
  router.mount('/api/', userRoutes.router);

  // Correctly apply the middleware
  final handler = Pipeline()
    .addMiddleware(logRequests())  // Use parentheses to get the middleware function
    .addHandler(router);
  
  final server = await io.serve(handler, 'localhost', 8080);
  print('Server running on http://${server.address.host}:${server.port}');
}

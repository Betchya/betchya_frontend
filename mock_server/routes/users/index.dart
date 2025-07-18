import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  final path = context.request.uri.path;

  if (path == '/users') {
    return _getUsers();
  }

  return Response(statusCode: 404, body: path);
}

Response _getUsers() {
  return Response.json(
    body: {'endpointCalled': 'GET /users', 'message': 'List of users'},
  );
}

import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  final posts = [
    {'id': 1, 'title': 'First Post', 'content': 'This is the first post.'},
    {'id': 2, 'title': 'Second Post', 'content': 'This is the second post.'},
  ];
  return Response.json(body: posts);
}

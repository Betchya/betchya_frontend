// ignore_for_file: file_names

import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context, String id) {
  final post = {
    'id': id,
    'title': 'Post $id',
    'content': 'This is the content of post $id.',
  };
  return Response.json(body: post);
}

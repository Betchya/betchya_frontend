// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, implicit_dynamic_list_literal

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';


import '../routes/users/index.dart' as users_index;
import '../routes/posts/index.dart' as posts_index;
import '../routes/posts/[id].dart' as posts_$id;


void main() async {
  final address = InternetAddress.tryParse('') ?? InternetAddress.anyIPv6;
  final port = int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080;
  hotReload(() => createServer(address, port));
}

Future<HttpServer> createServer(InternetAddress address, int port) {
  final handler = Cascade().add(buildRootHandler()).handler;
  return serve(handler, address, port);
}

Handler buildRootHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..mount('/posts', (context) => buildPostsHandler()(context))
    ..mount('/users', (context) => buildUsersHandler()(context));
  return pipeline.addHandler(router);
}

Handler buildPostsHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => posts_index.onRequest(context,))..all('/<id>', (context,id,) => posts_$id.onRequest(context,id,));
  return pipeline.addHandler(router);
}

Handler buildUsersHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => users_index.onRequest(context,));
  return pipeline.addHandler(router);
}


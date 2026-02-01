import 'package:auth_repository/auth_repository.dart';
import 'package:betchya_frontend/bootstrap.dart';
import 'package:betchya_frontend/src/app.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL'),
    anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
  );

  final authRepository = AuthRepository(
    supabaseClient: Supabase.instance.client,
  );

  await bootstrap(() => App(authRepository: authRepository));
}

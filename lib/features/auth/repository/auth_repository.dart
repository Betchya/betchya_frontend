import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  AuthRepository({required this.supabaseClient});

  final SupabaseClient supabaseClient;

  Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    final response = await supabaseClient.auth.signUp(
      email: email,
      password: password,
    );
    return response.user;
  }

  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    final response = await supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response.user;
  }

  Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }

  User? getCurrentUser() {
    return supabaseClient.auth.currentUser;
  }
}

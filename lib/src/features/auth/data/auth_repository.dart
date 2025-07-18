import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  AuthRepository({required this.supabaseClient});

  final SupabaseClient supabaseClient;

  User? get currentUser => supabaseClient.auth.currentUser;

  // Stream that emits the current user on any auth state change
  Stream<User?> get authStateChanges =>
      supabaseClient.auth.onAuthStateChange.map((event) => event.session?.user);

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
}

import 'package:supabase_flutter/supabase_flutter.dart';

/// {@template auth_repository}
/// Repository which manages user authentication.
/// {@endtemplate}
class AuthRepository {
  /// {@macro auth_repository}
  const AuthRepository({required SupabaseClient supabaseClient})
      : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  /// Returns the current authenticated [User] if one exists.
  User? get currentUser => _supabaseClient.auth.currentUser;

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  Stream<User?> get authStateChanges => _supabaseClient.auth.onAuthStateChange
      .map((event) => event.session?.user);

  /// Signs up with [email] and [password].
  Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    final response = await _supabaseClient.auth.signUp(
      email: email,
      password: password,
    );
    return response.user;
  }

  /// Signs in with [email] and [password].
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response.user;
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
  }

  /// Sends a password reset email to [email].
  Future<void> resetPasswordForEmail({required String email}) async {
    await _supabaseClient.auth.resetPasswordForEmail(email);
  }
}

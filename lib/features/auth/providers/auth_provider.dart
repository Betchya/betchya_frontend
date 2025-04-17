import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_provider.g.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

@riverpod
class Auth extends _$Auth {
  @override
  User? build() {
    return ref.watch(supabaseClientProvider).auth.currentUser;
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    final response = await ref.read(supabaseClientProvider).auth.signUp(
      email: email,
      password: password,
    );
    state = response.user;
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final response = await ref.read(supabaseClientProvider).auth.signInWithPassword(
      email: email,
      password: password,
    );
    state = response.user;
  }

  Future<void> signOut() async {
    try {
      await ref.read(supabaseClientProvider).auth.signOut();
      state = null;
    } catch (e) {
      rethrow;
    }
  }
}

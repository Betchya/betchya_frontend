import 'package:betchya_frontend/features/auth/repository/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_provider.g.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthRepository(supabaseClient: client);
});

@riverpod
class AuthController extends _$AuthController {
  AuthController();

  AuthRepository get _authRepository => ref.read(authRepositoryProvider);

  @override
  User? build() {
    return _authRepository.getCurrentUser();
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    final user = await _authRepository.signUp(email: email, password: password);
    state = user;
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final user = await _authRepository.signIn(email: email, password: password);
    state = user;
  }

  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
      state = null;
    } catch (e) {
      rethrow;
    }
  }
}

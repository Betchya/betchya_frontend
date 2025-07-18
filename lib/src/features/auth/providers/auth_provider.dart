import 'package:betchya_frontend/src/core/providers/supabase_providers.dart';
import 'package:betchya_frontend/src/features/auth/repository/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show User;

part 'auth_provider.g.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthRepository(supabaseClient: client);
});

@riverpod
class AuthController extends _$AuthController {
  AuthController();

  AuthRepository get _authRepository => ref.read(authRepositoryProvider);

  @override
  Future<User?> build() async {
    return _authRepository.currentUser;
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    state = await AsyncValue.guard(
      () => _authRepository.signUp(email: email, password: password),
    );
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = await AsyncValue.guard(
      () => _authRepository.signIn(email: email, password: password),
    );
  }

  Future<void> signOut() async {
    state = await AsyncValue.guard(() async {
      await _authRepository.signOut();
      return null; // <-- this sets the state to AsyncValue.data(null)
    });
  }
}

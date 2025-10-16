import 'package:betchya_frontend/src/features/auth/domain/email_input.dart';
import 'package:betchya_frontend/src/features/auth/domain/date_of_birth_input.dart';
import 'package:betchya_frontend/src/features/auth/data/auth_repository.dart';
import 'package:betchya_frontend/src/features/auth/presentation/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

class ForgotLoginInfoState {
  const ForgotLoginInfoState({
    this.email = const EmailInput.pure(),
    this.dob = const DateOfBirthInput.pure(),
    this.status = FormzStatus.pure,
    this.dobObscured = true,
  });

  final EmailInput email;
  final DateOfBirthInput dob;
  final FormzStatus status;
  final bool dobObscured;

  ForgotLoginInfoState copyWith({
    EmailInput? email,
    DateOfBirthInput? dob,
    FormzStatus? status,
    bool? dobObscured,
  }) {
    return ForgotLoginInfoState(
      email: email ?? this.email,
      dob: dob ?? this.dob,
      status: status ?? this.status,
      dobObscured: dobObscured ?? this.dobObscured,
    );
  }
}

class ForgotLoginInfoController extends StateNotifier<ForgotLoginInfoState> {
  ForgotLoginInfoController(this._authRepository) : super(const ForgotLoginInfoState());
  
  final AuthRepository _authRepository; // Will be used for actual API calls

  void emailChanged(String value) {
    final email = EmailInput.dirty(value);
    state = state.copyWith(
      email: email,
      status: Formz.validate([email, state.dob]),
    );
  }

  void dobChanged(String value) {
    final dob = DateOfBirthInput.dirty(value);
    state = state.copyWith(
      dob: dob,
      status: Formz.validate([state.email, dob]),
    );
  }

  void toggleDobObscured() {
    state = state.copyWith(dobObscured: !state.dobObscured);
  }

  void validateAll() {
    final email = EmailInput.dirty(state.email.value);
    final dob = DateOfBirthInput.dirty(state.dob.value);
    state = state.copyWith(
      email: email,
      dob: dob,
      status: Formz.validate([email, dob]),
    );
  }

  Future<void> submit() async {
    if (state.status != FormzStatus.valid) return;
    
    try {
      // TODO: Implement actual forgot login info API call
      // For now, simulate the call
      await Future<void>.delayed(const Duration(seconds: 1));
      
      // Reset form on success
      state = const ForgotLoginInfoState();
    } catch (e) {
      // Error handling will be managed by the AsyncValue pattern
      rethrow;
    }
  }
}

final forgotLoginInfoControllerProvider = StateNotifierProvider.autoDispose<ForgotLoginInfoController, ForgotLoginInfoState>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return ForgotLoginInfoController(authRepository);
});

// State for tracking submission status
final forgotLoginInfoSubmissionStateProvider = StateProvider<AsyncValue<void>?>((ref) => null);
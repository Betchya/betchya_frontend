import 'package:betchya_frontend/features/auth/models/dob_input.dart';
import 'package:betchya_frontend/features/auth/models/email_input.dart';
import 'package:betchya_frontend/features/auth/models/password_input.dart';
import 'package:betchya_frontend/features/auth/providers/auth_provider.dart';
import 'package:betchya_frontend/features/auth/repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

class SignUpFormState {
  const SignUpFormState({
    this.email = const EmailInput.pure(),
    this.password = const PasswordInput.pure(),
    this.dob = const DOBInput.pure(),
    this.status = FormzStatus.pure,
    this.error,
    this.isSubmitting = false,
  });
  final EmailInput email;
  final PasswordInput password;
  final DOBInput dob;
  final FormzStatus status;
  final String? error;
  final bool isSubmitting;

  SignUpFormState copyWith({
    EmailInput? email,
    PasswordInput? password,
    DOBInput? dob,
    FormzStatus? status,
    String? error,
    bool? isSubmitting,
  }) {
    return SignUpFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      dob: dob ?? this.dob,
      status: status ?? this.status,
      error: error,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class SignUpFormController extends StateNotifier<SignUpFormState> {
  SignUpFormController(this._authRepository) : super(const SignUpFormState());
  final AuthRepository _authRepository;

  void emailChanged(String value) {
    final email = EmailInput.dirty(value);
    state = state.copyWith(
      email: email,
      status: Formz.validate([email, state.password, state.dob]),
    );
  }

  void passwordChanged(String value) {
    final password = PasswordInput.dirty(value);
    state = state.copyWith(
      password: password,
      status: Formz.validate([state.email, password, state.dob]),
    );
  }

  void dobChanged(String value) {
    final dob = DOBInput.dirty(value);
    state = state.copyWith(
      dob: dob,
      status: Formz.validate([state.email, state.password, dob]),
    );
  }

  Future<void> submit() async {
    if (state.status != FormzStatus.valid) return;
    state = state.copyWith(isSubmitting: true);
    try {
      await _authRepository.signUp(
        email: state.email.value,
        password: state.password.value,
      );
      state = state.copyWith(isSubmitting: false);
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
    }
  }
}

final signUpFormControllerProvider =
    StateNotifierProvider.autoDispose<SignUpFormController, SignUpFormState>(
        (ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return SignUpFormController(authRepository);
});

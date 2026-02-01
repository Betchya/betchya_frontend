import 'package:auth_repository/auth_repository.dart';
import 'package:betchya_frontend/src/features/auth/domain/date_of_birth_input.dart';
import 'package:betchya_frontend/src/features/auth/domain/email_input.dart';
import 'package:betchya_frontend/src/features/auth/presentation/login/cubit/forgot_login_state.dart';
import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';

class ForgotLoginCubit extends Cubit<ForgotLoginState> {
  ForgotLoginCubit(this._authRepository) : super(const ForgotLoginState());

  final AuthRepository _authRepository;

  void emailChanged(String value) {
    final email = EmailInput.dirty(value);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([email, state.dob]),
      ),
    );
  }

  void dobChanged(String value) {
    final dob = DateOfBirthInput.dirty(value);
    emit(
      state.copyWith(
        dob: dob,
        isValid: Formz.validate([state.email, dob]),
      ),
    );
  }

  void toggleDobObscured() {
    emit(state.copyWith(dobObscured: !state.dobObscured));
  }

  Future<void> submit() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _authRepository.resetPasswordForEmail(email: state.email.value);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString,
          status: FormzSubmissionStatus.failure,
        ),
      );
    }
  }
}

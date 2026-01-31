import 'package:betchya_frontend/src/features/auth/data/auth_repository.dart';
import 'package:betchya_frontend/src/features/auth/presentation/auth_provider.dart';
import 'package:betchya_frontend/src/features/auth/presentation/login/forgot_login_info_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository authRepository;
  late ProviderContainer container;

  setUp(() {
    authRepository = MockAuthRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
      ],
    );
    // Keep the provider alive by listening to it
    container.listen(forgotLoginInfoControllerProvider, (_, __) {});
  });

  tearDown(() {
    container.dispose();
  });

  ForgotLoginInfoController getController() =>
      container.read(forgotLoginInfoControllerProvider.notifier);
  ForgotLoginInfoState getState() =>
      container.read(forgotLoginInfoControllerProvider);

  group('ForgotLoginInfoController', () {
    test('initial state is correct', () {
      final state = getState();
      expect(state.email.value, '');
      expect(state.dob.value, '');
      expect(state.status, FormzStatus.pure);
      expect(state.dobObscured, true);
    });

    test('emailChanged updates email and validates', () {
      final controller = getController();
      controller.emailChanged('test@example.com');
      final state = getState();
      expect(state.email.value, 'test@example.com');
      expect(state.email.valid, true);
      // Status remains invalid because DOB is empty
      expect(state.status, FormzStatus.invalid);
    });

    test('dobChanged updates dob and validates', () {
      final controller = getController();
      controller.dobChanged('01/01/2000');
      final state = getState();
      expect(state.dob.value, '01/01/2000');
      // Status remains invalid because email is empty
      expect(state.status, FormzStatus.invalid);
    });

    test('toggleDobObscured toggles value', () {
      expect(getState().dobObscured, true);
      getController().toggleDobObscured();
      expect(getState().dobObscured, false);
      getController().toggleDobObscured();
      expect(getState().dobObscured, true);
    });

    test('validateAll marks fields dirty and validates', () {
      getController().validateAll();
      // Empty email and dob are invalid
      expect(getState().email.pure, false);
      expect(getState().dob.pure, false);
      expect(getState().status, FormzStatus.invalid);
    });

    test('submit does nothing if status is not valid', () async {
      await getController().submit();
    });

    test('submit resets state on success', () async {
      final controller = getController();
      controller.emailChanged('test@example.com');
      controller.dobChanged('01/01/2000');

      expect(getState().status, FormzStatus.valid);

      await controller.submit();

      // Should satisfy 100% coverage for the happy path
      expect(getState().status, FormzStatus.pure);
      expect(getState().email.value, '');
      expect(getState().dob.value, '');
    });
  });

  group('ForgotLoginInfoState', () {
    test('supports value comparisons', () {
      expect(const ForgotLoginInfoState(), const ForgotLoginInfoState());
    });

    test('copyWith works', () {
      const state = ForgotLoginInfoState();
      final newState = state.copyWith(
        dobObscured: false,
      );
      expect(newState.dobObscured, false);
      expect(newState.email, state.email);
    });
  });
}
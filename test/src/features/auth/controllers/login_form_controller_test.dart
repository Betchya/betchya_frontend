import 'package:betchya_frontend/src/features/auth/controllers/login_form_controller.dart';
import 'package:betchya_frontend/src/features/auth/models/email_input.dart';
import 'package:betchya_frontend/src/features/auth/models/password_input.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';

void main() {
  late LoginFormController controller;

  const testEmail = 'test@example.com';
  const testPassword = 'Test1234';

  setUp(() {
    controller = LoginFormController();
  });

  group('LoginFormState', () {
    test('initial state is correct', () {
      expect(controller.state.email, const EmailInput.pure());
      expect(controller.state.password, const PasswordInput.pure());
      expect(controller.state.status, FormzStatus.pure);
      expect(controller.state.error, isNull);
      expect(controller.state.isSubmitting, isFalse);
    });

    test('copyWith updates all fields correctly', () {
      const initial = LoginFormState();
      final updated = initial.copyWith(
        email: const EmailInput.dirty('foo@bar.com'),
        password: const PasswordInput.dirty('pw'),
        status: FormzStatus.valid,
        error: 'err',
        isSubmitting: true,
      );
      expect(updated.email, const EmailInput.dirty('foo@bar.com'));
      expect(updated.password, const PasswordInput.dirty('pw'));
      expect(updated.status, FormzStatus.valid);
      expect(updated.error, 'err');
      expect(updated.isSubmitting, true);
    });

    test('copyWith falls back to previous status when status is not provided',
        () {
      const initial = LoginFormState(
        status: FormzStatus.invalid,
      );
      final updated = initial.copyWith(
        email: const EmailInput.dirty('foo@bar.com'),
      );
      expect(updated.status, FormzStatus.invalid);
    });
  });

  group('LoginFormController', () {
    test('initial state is correct', () {
      expect(controller.state.email, const EmailInput.pure());
      expect(controller.state.password, const PasswordInput.pure());
      expect(controller.state.status, FormzStatus.pure);
      expect(controller.state.error, isNull);
      expect(controller.state.isSubmitting, isFalse);
    });

    test('loginFormControllerProvider provides a LoginFormController', () {
      final controller =
          ProviderContainer().read(loginFormControllerProvider.notifier);
      expect(controller, isA<LoginFormController>());
    });

    group('emailChanged', () {
      test('updates email and validates form', () {
        // Act
        controller.emailChanged(testEmail);

        // Assert
        expect(controller.state.email.value, testEmail);
        expect(controller.state.status, FormzStatus.invalid);
      });
    });

    group('passwordChanged', () {
      test('updates password and validates form', () {
        // Act
        controller.passwordChanged(testPassword);

        // Assert
        expect(controller.state.password.value, testPassword);
        expect(controller.state.status, FormzStatus.invalid);
      });
    });
  });
}

import 'package:betchya_frontend/src/features/home/presentation/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Robot for interacting with and asserting on the SignUpScreen UI.
class SignUpScreenRobot {
  const SignUpScreenRobot(this.tester);

  final WidgetTester tester;

  /// Finds and enters text into the full name field.
  Future<void> enterFullName(String name) async {
    final fullNameField = find.byKey(const Key('signup_full_name_field'));
    await tester.enterText(fullNameField, name);
    await tester.pumpAndSettle();
  }

  /// Finds and enters text into the email field.
  Future<void> enterEmail(String email) async {
    final emailField = find.byKey(const Key('signup_email_field'));
    await tester.enterText(emailField, email);
    await tester.pumpAndSettle();
  }

  /// Finds and enters text into the password field.
  Future<void> enterPassword(String password) async {
    final passwordField = find.byKey(const Key('signup_password_field'));
    await tester.enterText(passwordField, password);
    await tester.pumpAndSettle();
  }

  /// Finds and enters text into the confirm password field.
  Future<void> enterConfirmPassword(String password) async {
    final confirmPasswordField =
        find.byKey(const Key('signup_confirm_password_field'));
    await tester.enterText(confirmPasswordField, password);
    await tester.pumpAndSettle();
  }

  /// Taps the signup button.
  Future<void> tapSignupButton() async {
    final signupButton = find.byKey(const Key('signup_button'));
    await tester.tap(signupButton);
    await tester.pumpAndSettle();
  }

  /// Asserts that an error message is shown.
  Future<void> expectErrorMessage(String message) async {
    expect(find.text(message), findsOneWidget);
  }

  /// Asserts that navigation to the home screen occurred.
  Future<void> expectNavigatedToHome() async {
    expect(find.byType(HomeScreen), findsOneWidget);
  }

  /// Asserts that all required input fields are present.
  Future<void> expectFieldsPresent() async {
    expect(find.byKey(const Key('signup_full_name_field')), findsOneWidget);
    expect(find.byKey(const Key('signup_email_field')), findsOneWidget);
    expect(find.byKey(const Key('signup_password_field')), findsOneWidget);
    expect(
      find.byKey(const Key('signup_confirm_password_field')),
      findsOneWidget,
    );
  }
}

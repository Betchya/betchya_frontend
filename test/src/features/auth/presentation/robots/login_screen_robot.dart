import 'package:betchya_frontend/src/features/home/presentation/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Robot for interacting with and asserting on the LoginScreen UI.
class LoginScreenRobot {
  const LoginScreenRobot(this.tester);

  final WidgetTester tester;

  /// Finds and enters text into the email field.
  Future<void> enterEmail(String email) async {
    // TODO: Update with the correct key or finder for the email field
    final emailField = find.byKey(const Key('login_email_field'));
    await tester.enterText(emailField, email);
    await tester.pumpAndSettle();
  }

  /// Finds and enters text into the password field.
  Future<void> enterPassword(String password) async {
    // TODO: Update with the correct key or finder for the password field
    final passwordField = find.byKey(const Key('login_password_field'));
    await tester.enterText(passwordField, password);
    await tester.pumpAndSettle();
  }

  /// Taps the login button.
  Future<void> tapLoginButton() async {
    final loginButton = find.byKey(const Key('login_button'));
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
  }

  /// Asserts that all required input fields and buttons are present.
  Future<void> expectFieldsPresent() async {
    expect(find.byKey(const Key('login_email_field')), findsOneWidget);
    expect(find.byKey(const Key('login_password_field')), findsOneWidget);
    expect(find.byKey(const Key('login_button')), findsOneWidget);
    expect(find.byKey(const Key('login_forgot_info')), findsOneWidget);
  }

  /// Asserts that the login button is enabled or disabled.
  Future<void> expectLoginButtonEnabled({required bool isEnabled}) async {
    final loginButton = find.byKey(const Key('login_button'));
    final buttonWidget = tester.widget<ElevatedButton>(loginButton);
    if (isEnabled) {
      expect(buttonWidget.onPressed, isNotNull);
    } else {
      expect(buttonWidget.onPressed, isNull);
    }
  }

  /// Asserts that an error message is shown.
  Future<void> expectErrorMessage(String message) async {
    expect(find.text(message), findsOneWidget);
  }

  /// Asserts that navigation to the home screen occurred.
  Future<void> expectNavigatedToHome() async {
    expect(find.byType(HomeScreen), findsOneWidget);
  }
}

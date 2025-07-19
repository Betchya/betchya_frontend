import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Robot for interacting with and asserting on the Auth feature
/// (login & signup flows).
class AuthRobot {
  const AuthRobot(this.tester);

  final WidgetTester tester;

  // --- Login ---
  Future<void> enterLoginEmail(String email) async {
    final emailField = find.byKey(const Key('login_email_field'));
    await tester.enterText(emailField, email);
    await tester.pumpAndSettle();
  }

  Future<void> enterLoginPassword(String password) async {
    final passwordField = find.byKey(const Key('login_password_field'));
    await tester.enterText(passwordField, password);
    await tester.pumpAndSettle();
  }

  Future<void> tapLoginButton() async {
    final loginButton = find.byKey(const Key('login_button'));
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
  }

  Future<void> expectLoginFieldsPresent() async {
    expect(find.byKey(const Key('login_email_field')), findsOneWidget);
    expect(find.byKey(const Key('login_password_field')), findsOneWidget);
    expect(find.byKey(const Key('login_button')), findsOneWidget);
    expect(find.byKey(const Key('login_forgot_info')), findsOneWidget);
  }

  Future<void> expectLoginButtonEnabled({required bool isEnabled}) async {
    final loginButton = find.byKey(const Key('login_button'));
    final buttonWidget = tester.widget<ElevatedButton>(loginButton);
    if (isEnabled) {
      expect(buttonWidget.onPressed, isNotNull);
    } else {
      expect(buttonWidget.onPressed, isNull);
    }
  }

  // --- Signup ---
  Future<void> enterFullName(String name) async {
    final fullNameField = find.byKey(const Key('signup_full_name_field'));
    await tester.enterText(fullNameField, name);
    await tester.pumpAndSettle();
  }

  Future<void> enterSignupEmail(String email) async {
    final emailField = find.byKey(const Key('signup_email_field'));
    await tester.enterText(emailField, email);
    await tester.pumpAndSettle();
  }

  Future<void> enterSignupPassword(String password) async {
    final passwordField = find.byKey(const Key('signup_password_field'));
    await tester.enterText(passwordField, password);
    await tester.pumpAndSettle();
  }

  Future<void> enterConfirmPassword(String password) async {
    final confirmPasswordField =
        find.byKey(const Key('signup_confirm_password_field'));
    await tester.enterText(confirmPasswordField, password);
    await tester.pumpAndSettle();
  }

  Future<void> tapSignupButton() async {
    final signupButton = find.byKey(const Key('signup_button'));
    await tester.tap(signupButton);
    await tester.pumpAndSettle();
  }

  Future<void> expectSignupFieldsPresent() async {
    expect(find.byKey(const Key('signup_full_name_field')), findsOneWidget);
    expect(find.byKey(const Key('signup_email_field')), findsOneWidget);
    expect(find.byKey(const Key('signup_password_field')), findsOneWidget);
    expect(
      find.byKey(const Key('signup_confirm_password_field')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('signup_button')), findsOneWidget);
  }

  // --- Shared / Integration ---
  Future<void> expectErrorMessage(String message) async {
    expect(find.text(message), findsOneWidget);
  }

  Future<void> expectNavigatedToHome() async {
    expect(find.text('Welcome!'), findsOneWidget);
  }
}

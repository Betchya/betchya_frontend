import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Robot for interacting with and asserting on the SignUpScreen UI.
class SignUpScreenRobot {
  const SignUpScreenRobot(this.tester);

  final WidgetTester tester;

  /// Finds and enters text into the email field.
  Future<void> enterEmail(String email) async {
    // TODO: Update with the correct key or finder for the email field
    final emailField = find.byKey(const Key('signup_email_field'));
    await tester.enterText(emailField, email);
    await tester.pumpAndSettle();
  }

  /// Finds and enters text into the password field.
  Future<void> enterPassword(String password) async {
    // TODO: Update with the correct key or finder for the password field
    final passwordField = find.byKey(const Key('signup_password_field'));
    await tester.enterText(passwordField, password);
    await tester.pumpAndSettle();
  }

  /// Finds and enters text into the confirm password field.
  Future<void> enterConfirmPassword(String password) async {
    // TODO: Update with the correct key or finder for the confirm password field
    final confirmPasswordField =
        find.byKey(const Key('signup_confirm_password_field'));
    await tester.enterText(confirmPasswordField, password);
    await tester.pumpAndSettle();
  }

  /// Taps the signup button.
  Future<void> tapSignupButton() async {
    // TODO: Update with the correct key or finder for the signup button
    final signupButton = find.byKey(const Key('signup_button'));
    await tester.tap(signupButton);
    await tester.pumpAndSettle();
  }

  /// Asserts that an error message is shown.
  Future<void> expectErrorMessage(String message) async {
    expect(find.text(message), findsOneWidget);
  }

  /// Asserts that the loading indicator is shown.
  Future<void> expectLoading() async {
    // TODO: Update with the correct finder for the loading indicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  }

  /// Asserts that navigation to the home screen occurred.
  Future<void> expectNavigatedToHome() async {
    // TODO: Implement navigation assertion
  }

  /// Asserts that all required input fields are present.
  Future<void> expectFieldsPresent() async {
    // TODO: Update with the correct keys or finders for all fields
    expect(find.byKey(const Key('signup_email_field')), findsOneWidget);
    expect(find.byKey(const Key('signup_password_field')), findsOneWidget);
    expect(
      find.byKey(const Key('signup_confirm_password_field')),
      findsOneWidget,
    );
  }
}

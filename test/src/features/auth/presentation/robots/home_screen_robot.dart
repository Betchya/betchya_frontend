import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Robot for interacting with and asserting on the HomeScreen UI.
class HomeScreenRobot {
  const HomeScreenRobot(this.tester);

  final WidgetTester tester;

  /// Asserts that the main UI elements are present.
  Future<void> expectMainElementsPresent() async {
    // TODO: Update with the correct keys or finders for the main elements
    expect(find.byKey(const Key('home_main_content')), findsOneWidget);
  }

  /// Asserts that the user info is displayed correctly.
  Future<void> expectUserInfo(String email) async {
    // TODO: Update with the correct finder for user info
    expect(find.text(email), findsOneWidget);
  }

  /// Taps a navigation button.
  Future<void> tapNavigationButton(String buttonKey) async {
    // TODO: Update with the correct key or finder for navigation buttons
    final navButton = find.byKey(Key(buttonKey));
    await tester.tap(navButton);
    await tester.pumpAndSettle();
  }

  /// Asserts that the loading indicator is shown.
  Future<void> expectLoading() async {
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  }

  /// Asserts that an error message is shown.
  Future<void> expectErrorMessage(String message) async {
    expect(find.text(message), findsOneWidget);
  }
}

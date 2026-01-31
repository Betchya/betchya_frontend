import 'package:betchya_frontend/src/features/auth/data/auth_repository.dart';
import 'package:betchya_frontend/src/features/auth/presentation/auth_provider.dart';
import 'package:betchya_frontend/src/features/auth/presentation/login/forgot_login_info.dart';
import 'package:betchya_frontend/src/features/auth/presentation/login/forgot_login_info_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository),
        ],
        child: MaterialApp(
          initialRoute: '/',
          routes: {
            '/': (context) => const Scaffold(body: Text('Home Screen')),
            '/forgot': (context) => const ForgotLoginInfoScreen(),
          },
        ),
      ),
    );
    // Push the screen
    tester.state<NavigatorState>(find.byType(Navigator)).pushNamed('/forgot');
    await tester.pumpAndSettle();
  }

  group('ForgotLoginInfoScreen', () {
    testWidgets('renders all required input fields', (tester) async {
      await pumpScreen(tester);

      expect(find.byKey(const Key('forgot_login_email_field')), findsOneWidget);
      expect(find.byKey(const Key('forgot_login_dob_field')), findsOneWidget);
      expect(
        find.byKey(const Key('forgot_login_submit_button')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('forgot_login_back_button')), findsOneWidget);
    });

    testWidgets('shows validation errors for invalid email', (tester) async {
      await pumpScreen(tester);

      await tester.enterText(
        find.byKey(const Key('forgot_login_email_field')),
        'notanemail',
      );
      await tester.pumpAndSettle();

      expect(find.text('Invalid email'), findsOneWidget);
    });

    testWidgets('submit button is disabled when form is invalid',
        (tester) async {
      await pumpScreen(tester);

      final submitButton = tester.widget<ElevatedButton>(
        find.byKey(const Key('forgot_login_submit_button')),
      );
      expect(submitButton.onPressed, isNull);
    });

    testWidgets('submit button is enabled when form is valid', (tester) async {
      await pumpScreen(tester);

      await tester.enterText(
        find.byKey(const Key('forgot_login_email_field')),
        'test@example.com',
      );
      // Enter a valid date (must be > 13 years old, let's say 2000)
      await tester.enterText(
        find.byKey(const Key('forgot_login_dob_field')),
        '01/01/2000',
      );

      await tester.pumpAndSettle();

      final submitButton = tester.widget<ElevatedButton>(
        find.byKey(const Key('forgot_login_submit_button')),
      );
      expect(submitButton.onPressed, isNotNull);
    });

    testWidgets('DateInputFormatter formats input correctly', (tester) async {
      await pumpScreen(tester);

      final dobField = find.byKey(const Key('forgot_login_dob_field'));

      // Test "1" -> "1"
      await tester.enterText(dobField, '1');
      expect(find.text('1'), findsOneWidget);

      // Test "12" -> "12/"
      await tester.enterText(dobField, '12');
      expect(find.text('12/'), findsOneWidget);

      // Test "123" -> "12/3"
      await tester.enterText(dobField, '123');
      expect(find.text('12/3'), findsOneWidget);

      // Test "1234" -> "12/34/"
      await tester.enterText(dobField, '1234');
      expect(find.text('12/34/'), findsOneWidget);

      // Test "12345" -> "12/34/5"
      await tester.enterText(dobField, '12345');
      expect(find.text('12/34/5'), findsOneWidget);

      // Test > 8 digits (truncation)
      await tester.enterText(dobField, '123456789');
      // 12345678 -> 12/34/5678
      expect(find.text('12/34/5678'), findsOneWidget);
    });

    testWidgets('shows date picker when icon is pressed', (tester) async {
      await pumpScreen(tester);

      await tester.tap(find.byIcon(Icons.calendar_today));
      await tester.pumpAndSettle();

      expect(find.byType(DatePickerDialog), findsOneWidget);

      // Select a date (e.g., Cancel)
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(DatePickerDialog), findsNothing);
    });

    testWidgets('updates text field when date is picked', (tester) async {
      await pumpScreen(tester);

      await tester.tap(find.byIcon(Icons.calendar_today));
      await tester.pumpAndSettle();

      // Tap 'OK' (defaults to current selection which might be out of range if not careful,
      // but the picker is set to 25 years ago by default in the code)
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      final dobField = tester
          .widget<TextField>(find.byKey(const Key('forgot_login_dob_field')));
      expect(dobField.controller!.text, isNotEmpty);
    });

    testWidgets('toggles DOB visibility', (tester) async {
      await pumpScreen(tester);

      final dobFieldFinder = find.byKey(const Key('forgot_login_dob_field'));
      var dobField = tester.widget<TextField>(dobFieldFinder);
      expect(dobField.obscureText, isTrue);

      await tester.tap(find.text('Show'));
      await tester.pump();

      dobField = tester.widget<TextField>(dobFieldFinder);
      expect(dobField.obscureText, isFalse);

      await tester.tap(find.text('Hide'));
      await tester.pump();

      dobField = tester.widget<TextField>(dobFieldFinder);
      expect(dobField.obscureText, isTrue);
    });

    testWidgets('updates text field when state changes', (tester) async {
      await pumpScreen(tester);

      final dobFieldFinder = find.byKey(const Key('forgot_login_dob_field'));
      var dobField = tester.widget<TextField>(dobFieldFinder);
      expect(dobField.controller!.text, isEmpty);

      // Update state manually
      final element = tester.element(find.byType(ForgotLoginInfoScreen));
      final container = ProviderScope.containerOf(element);
      container
          .read(forgotLoginInfoControllerProvider.notifier)
          .dobChanged('12/12/2012');

      await tester.pump();

      dobField = tester.widget<TextField>(dobFieldFinder);
      expect(dobField.controller!.text, '12/12/2012');
    });

    testWidgets('shows success snackbar and pops on success', (tester) async {
      await pumpScreen(tester);

      await tester.enterText(
        find.byKey(const Key('forgot_login_email_field')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('forgot_login_dob_field')),
        '01/01/2000',
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('forgot_login_submit_button')));

      // The controller has a 1 second delay
      await tester.pump(const Duration(milliseconds: 1100));
      await tester.pumpAndSettle();

      // Verify the screen has popped (is no longer in the tree)
      expect(find.byKey(const Key('forgot_login_submit_button')), findsNothing);
    });

    testWidgets('DateInputFormatter: TextSelection is preserved at end',
        (tester) async {
      final formatter = DateInputFormatter();
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(
        text: '12',
        selection: TextSelection.collapsed(offset: 2),
      );

      final result = formatter.formatEditUpdate(oldValue, newValue);
      expect(result.text, '12/');
      expect(result.selection.baseOffset, 3);
    });
  });
}

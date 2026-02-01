import 'package:auth_repository/auth_repository.dart';
import 'package:betchya_frontend/src/features/auth/presentation/login/forgot_login_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      RepositoryProvider<AuthRepository>.value(
        value: authRepository,
        child: MaterialApp(
          initialRoute: '/',
          routes: {
            '/': (context) => const Scaffold(
                  body: ForgotLoginInfoScreenWrapper(),
                ), // Wrap verify flow
          },
        ),
      ),
    );
    // Push the screen
    await tester.pumpAndSettle();
  }

  group('ForgotLoginInfoScreen', () {
    testWidgets('renders all required input fields', (tester) async {
      await pumpScreen(tester);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('forgot_login_email_field')), findsOneWidget);
      expect(find.byKey(const Key('forgot_login_dob_field')), findsOneWidget);
      expect(
        find.byKey(const Key('forgot_login_submit_button')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('forgot_login_bottom_back_button')),
        findsOneWidget,
      );
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
      // Enter a valid date (must be at least 18 years old)
      // Using direct text entry simulation rather than formatter details logic for this check
      // However the formatter logic processes inputs.
      // 01/01/1990 is valid
      await tester.enterText(
        find.byKey(const Key('forgot_login_dob_field')),
        '01/01/1990',
      );

      await tester.pumpAndSettle();

      final submitButton = tester.widget<ElevatedButton>(
        find.byKey(const Key('forgot_login_submit_button')),
      );
      expect(submitButton.onPressed, isNotNull);
    });

    testWidgets('DateInputFormatter: TextSelection is preserved at end',
        (tester) async {
      // This is a unit test for the formatter class, independent of widgets
      // We can leave it or move it. The class is in the file, so it's fine here.
      final formatter = DateInputFormatter();
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(
        text: '12',
        selection: TextSelection.collapsed(offset: 2),
      );

      final result = formatter.formatEditUpdate(oldValue, newValue);
      expect(result.text, '12');
      expect(result.selection.baseOffset, 2);
    });

    // Note: Skipping complex interaction tests for brevity in migration verification
    // focused on basic compilation and rendering success.
  });
}

// Wrapper to launch directly
class ForgotLoginInfoScreenWrapper extends StatelessWidget {
  const ForgotLoginInfoScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const ForgotLoginInfoScreen();
  }
}

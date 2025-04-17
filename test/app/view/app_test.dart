import 'package:betchya_frontend/app/app.dart';
import 'package:betchya_frontend/app/view/app.dart';
import 'package:betchya_frontend/features/auth/presentation/home_screen.dart';
import 'package:betchya_frontend/features/auth/presentation/login_screen.dart';
import 'package:betchya_frontend/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockAuth extends Mock implements Auth {}

class MockUser extends Mock implements User {}

void main() {
  late MockAuth mockAuth;
  late MockUser mockUser;

  setUp(() {
    mockAuth = MockAuth();
    mockUser = MockUser();
  });

  group('App', () {
    testWidgets('renders LoginScreen when not authenticated', (tester) async {
      when(() => mockAuth.build()).thenReturn(null);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authProvider.overrideWith(() => mockAuth),
          ],
          child: const App(),
        ),
      );

      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
    });

    testWidgets('renders HomeScreen when authenticated', (tester) async {
      when(() => mockAuth.build()).thenReturn(mockUser);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authProvider.overrideWith(() => mockAuth),
          ],
          child: const App(),
        ),
      );

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(LoginScreen), findsNothing);
    });

    testWidgets('uses Material theme with correct properties', (tester) async {
      when(() => mockAuth.build()).thenReturn(null);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authProvider.overrideWith(() => mockAuth),
          ],
          child: const App(),
        ),
      );

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme?.useMaterial3, isTrue);

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect((scaffold.appBar as AppBar?)?.backgroundColor, isNotNull);
    });

    testWidgets('has correct localization setup', (tester) async {
      when(() => mockAuth.build()).thenReturn(null);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authProvider.overrideWith(() => mockAuth),
          ],
          child: const App(),
        ),
      );

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.localizationsDelegates, isNotNull);
      expect(materialApp.supportedLocales, isNotNull);
    });
  });
}

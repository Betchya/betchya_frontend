import 'package:betchya_frontend/src/features/auth/bloc/auth_bloc.dart';
import 'package:betchya_frontend/src/features/home/presentation/home_screen.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockAuthBloc authBloc;

  setUp(() {
    authBloc = MockAuthBloc();
    // Default state
    when(() => authBloc.state).thenReturn(const AuthState.unauthenticated());
  });

  Future<void> pumpHomeScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      BlocProvider<AuthBloc>.value(
        value: authBloc,
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('HomeScreen', () {
    testWidgets('renders main UI elements', (tester) async {
      await pumpHomeScreen(tester);

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.byKey(const Key('home_logout_button')), findsOneWidget);
      expect(find.byIcon(Icons.logout), findsOneWidget);
      expect(find.text('Welcome!'), findsOneWidget);
    });

    testWidgets('adds AuthLogoutRequested when logout button is tapped',
        (tester) async {
      await pumpHomeScreen(tester);

      await tester.tap(find.byKey(const Key('home_logout_button')));
      await tester.pump();

      verify(() => authBloc.add(const AuthLogoutRequested())).called(1);
    });
  });
}

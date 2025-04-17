import 'package:betchya_frontend/features/auth/presentation/home_screen.dart';
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

  testWidgets('renders welcome message with email when user exists',
      (tester) async {
    when(() => mockUser.email).thenReturn('test@example.com');
    when(() => mockAuth.build()).thenReturn(mockUser);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(() => mockAuth),
        ],
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    expect(find.text('Welcome, test@example.com!'), findsOneWidget);
    expect(find.text('You are now logged in.'), findsOneWidget);
  });

  testWidgets('renders welcome message with "User" when email is null',
      (tester) async {
    when(() => mockUser.email).thenReturn(null);
    when(() => mockAuth.build()).thenReturn(mockUser);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(() => mockAuth),
        ],
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    expect(find.text('Welcome, User!'), findsOneWidget);
    expect(find.text('You are now logged in.'), findsOneWidget);
  });

  testWidgets('logout button calls signOut', (tester) async {
    when(() => mockUser.email).thenReturn('test@example.com');
    when(() => mockAuth.build()).thenReturn(mockUser);
    when(() => mockAuth.signOut()).thenAnswer((_) async {});

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(() => mockAuth),
        ],
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.logout));
    await tester.pump();

    verify(() => mockAuth.signOut()).called(1);
  });

  testWidgets('renders app bar with title and logout button', (tester) async {
    when(() => mockUser.email).thenReturn('test@example.com');
    when(() => mockAuth.build()).thenReturn(mockUser);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(() => mockAuth),
        ],
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    expect(find.text('Home'), findsOneWidget);
    expect(find.byIcon(Icons.logout), findsOneWidget);
  });
}

import 'package:betchya_frontend/features/auth/presentation/home_screen.dart';
import 'package:betchya_frontend/features/auth/presentation/login_screen.dart';
import 'package:betchya_frontend/features/auth/providers/auth_provider.dart';
import 'package:betchya_frontend/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider);

    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: user == null ? const LoginScreen() : const HomeScreen(),
    );
  }
}

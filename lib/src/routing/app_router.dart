import 'package:betchya_frontend/src/features/home/presentation/home_screen.dart';
import 'package:betchya_frontend/src/features/auth/presentation/login/login_screen.dart';
import 'package:betchya_frontend/src/features/auth/presentation/signup/signup_screen.dart';
import 'package:betchya_frontend/src/features/auth/presentation/auth_provider.dart';
import 'package:betchya_frontend/src/routing/go_router_refresh_stream.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  home,
  login,
  signUp,
}

// TODO(Josh-Sanford): add protected/authOnly routes as sets later if needed

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(
      authRepository.authStateChanges,
    ),
    redirect: (context, state) {
      // TODO(Josh-Sanford): consider updating to allow guests on home screen
      final isLoggedIn = authRepository.currentUser != null;
      final path = state.uri.path;

      if (isLoggedIn) {
        if (path == '/login' || path == '/login/signUp') {
          return '/';
        }
      } else {
        // Allow unauthenticated users to access /login and any /login/*
        if (!path.startsWith('/login')) {
          return '/login';
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.home.name,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        name: AppRoute.login.name,
        builder: (context, state) => const LoginScreen(),
        routes: [
          GoRoute(
            path: 'signUp',
            name: AppRoute.signUp.name,
            builder: (context, state) => const SignUpScreen(),
          ),
        ],
      ),
    ],
    // TODO(Josh-Sanford): add custom error screen when allowing guests users
    // errorBuilder: (context, state) => Scaffold(
    //   body: Center(child: Text('Error: ${state.error}')),
    // ),
  );
});

import 'package:auth_repository/auth_repository.dart';
import 'package:betchya_frontend/src/features/auth/presentation/login/cubit/login_cubit.dart';
import 'package:betchya_frontend/src/features/auth/presentation/login/cubit/login_state.dart';
import 'package:betchya_frontend/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(context.read<AuthRepository>()),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Authentication Failure'),
              ),
            );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: _LoginScreenContent(),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginScreenContent extends StatefulWidget {
  @override
  State<_LoginScreenContent> createState() => _LoginScreenContentState();
}

class _LoginScreenContentState extends State<_LoginScreenContent> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        SvgPicture.asset(
          'assets/images/betchya_logo_white.svg',
          height: 120,
        ),
        const SizedBox(height: 48),
        _EmailInput(),
        const SizedBox(height: 12),
        _PasswordInput(
          obscureText: _obscurePassword,
          onToggleObscure: () => setState(() {
            _obscurePassword = !_obscurePassword;
          }),
        ),
        const SizedBox(height: 24),
        _LoginButton(),
        const SizedBox(height: 32),
        _CreateAccountButton(),
        const SizedBox(height: 12),
        _ForgotLoginButton(),
      ],
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('login_email_field'),
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Email',
            errorText: state.email.isPure || state.email.isValid
                ? null
                : 'Invalid email',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({
    required this.obscureText,
    required this.onToggleObscure,
  });

  final bool obscureText;
  final VoidCallback onToggleObscure;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('login_password_field'),
          onChanged: (password) =>
              context.read<LoginCubit>().passwordChanged(password),
          obscureText: obscureText,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Password',
            errorText: state.password.isPure || state.password.isValid
                ? null
                : 'Invalid password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: onToggleObscure,
            ),
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            key: const Key('login_button'),
            onPressed: state.isValid
                ? () {
                    context.read<LoginCubit>().logInWithCredentials();
                  }
                : null,
            child: state.status.isInProgress
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    'Login',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class _CreateAccountButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const Key('login_create_account'),
      onTap: () {
        context.goNamed(AppRoute.signUp.name);
      },
      child: const Text(
        'Create Account',
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w400,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _ForgotLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const Key('login_forgot_info'),
      onTap: () {
        context.pushNamed(AppRoute.forgotLogin.name);
      },
      child: const Text(
        'Forgot Your Login Info?',
        style: TextStyle(
          color: Colors.white70,
          decoration: TextDecoration.underline,
          fontSize: 15,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

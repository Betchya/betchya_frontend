import 'package:betchya_frontend/features/auth/controllers/login_form_controller.dart';
import 'package:betchya_frontend/features/auth/presentation/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF22124B),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: _LoginScreenContent(),
          ),
        ),
      ),
    );
  }
}

class _LoginScreenContent extends ConsumerStatefulWidget {
  @override
  ConsumerState<_LoginScreenContent> createState() =>
      _LoginScreenContentState();
}

class _LoginScreenContentState extends ConsumerState<_LoginScreenContent> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(loginFormControllerProvider);
    final formController = ref.read(loginFormControllerProvider.notifier);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        // Logo
        SvgPicture.asset(
          'assets/images/betchya_logo_white.svg',
          height: 120,
        ),
        const SizedBox(height: 48),
        // Email
        TextField(
          key: const Key('login_email_field'),
          onChanged: formController.emailChanged,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Email',
            errorText: formState.email.invalid ? 'Invalid email' : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Password with show/hide
        TextField(
          key: const Key('login_password_field'),
          onChanged: formController.passwordChanged,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Password',
            errorText: formState.password.invalid ? 'Invalid password' : null,
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
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Login Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            key: const Key('login_button'),
            style: ElevatedButton.styleFrom(
              backgroundColor: formState.status == FormzStatus.valid &&
                      !formState.isSubmitting
                  ? const Color(0xFF1DD6C1)
                  : const Color(0x801DD6C1),
              disabledBackgroundColor: const Color(0x801DD6C1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed:
                formState.status == FormzStatus.valid && !formState.isSubmitting
                    ? formController.submit
                    : null,
            child: formState.isSubmitting
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
          ),
        ),
        if (formState.error != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              formState.error!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        const SizedBox(height: 32),
        // Create Account
        GestureDetector(
          key: const Key('login_create_account'),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<Widget>(
                builder: (context) => const SignUpScreen(),
              ),
            );
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
        ),
        const SizedBox(height: 12),
        // Forgot Login Info
        GestureDetector(
          key: const Key('login_forgot_info'),
          onTap: () {
            // TODO: Implement forgot login info navigation
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
        ),
      ],
    );
  }
}

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
    final formState = ref.watch(loginFormControllerProvider);
    final formController = ref.read(loginFormControllerProvider.notifier);
    return Scaffold(
      backgroundColor: const Color(0xFF22124B),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                _WelcomeHeader(
                  onRegisterTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<Widget>(
                        builder: (context) => const SignUpScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
                if (formState.error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      formState.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                const Text(
                  'Sign in with email',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
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
                TextField(
                  onChanged: formController.passwordChanged,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Password',
                    errorText:
                        formState.password.invalid ? 'Invalid password' : null,
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
                const SizedBox(height: 8),
                // Optionally: add remember me logic if needed
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
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
                    onPressed: formState.status == FormzStatus.valid &&
                            !formState.isSubmitting
                        ? formController.submit
                        : null,
                    child: formState.isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Sign in',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                _ForgotPasswordRow(),
                const SizedBox(height: 32),
                const _SocialLoginRow(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader({required this.onRegisterTap});

  final VoidCallback onRegisterTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Welcome!',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text(
              'Need an account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            GestureDetector(
              onTap: onRegisterTap,
              child: const Padding(
                padding: EdgeInsets.only(bottom: 2),
                child: Text(
                  'Register',
                  style: TextStyle(
                    color: Color(0xFF1DD6C1),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ForgotPasswordRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // TODO: Implement forgot password navigation
        },
        child: const Text(
          'Forgot password?',
          style: TextStyle(color: Color(0xFF1DD6C1)),
        ),
      ),
    );
  }
}

class _SocialLoginRow extends StatelessWidget {
  const _SocialLoginRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: SvgPicture.asset('assets/icons/google.svg', height: 32),
          onPressed: () {
            // TODO: Implement Google sign-in
          },
        ),
        IconButton(
          icon: SvgPicture.asset('assets/icons/apple.svg', height: 32),
          onPressed: () {
            // TODO: Implement Apple sign-in
          },
        ),
        IconButton(
          icon: SvgPicture.asset('assets/icons/facebook.svg', height: 32),
          onPressed: () {
            // TODO: Implement Facebook sign-in
          },
        ),
      ],
    );
  }
}

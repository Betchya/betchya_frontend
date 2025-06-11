import 'package:betchya_frontend/features/auth/controllers/sign_up_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(signUpFormControllerProvider);
    final formController = ref.read(signUpFormControllerProvider.notifier);
    return Scaffold(
      backgroundColor: const Color(0xFF22124B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Register',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const Text(
              'Sign up with email',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('signup_email_field'),
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
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('signup_dob_field'),
              onChanged: formController.dobChanged,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Date of Birth (mm/dd/yyyy)',
                errorText:
                    formState.dob.invalid ? 'Invalid date of birth' : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('signup_password_field'),
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
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('signup_confirm_password_field'),
              onChanged: formController.confirmPasswordChanged,
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Confirm Password',
                errorText: formState.confirmPassword.invalid
                    ? 'Passwords do not match'
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '8 or more characters\nAt least 1 capital letter, number & '
              'special character',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 24),
            if (formState.error != null) ...[
              Text(
                formState.error!,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 8),
            ],
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                key: const Key('signup_button'),
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
                        'Next',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 32),
            const Center(
              child: Text(
                'Or sign up with',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _SocialButton(asset: 'assets/icons/google.svg'),
                _SocialButton(asset: 'assets/icons/apple.svg'),
                _SocialButton(asset: 'assets/icons/facebook.svg'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: Implement social sign up
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: SvgPicture.asset(
            asset,
            width: 32,
            height: 32,
          ),
        ),
      ),
    );
  }
}

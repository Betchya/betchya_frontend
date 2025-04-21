import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:betchya_frontend/features/auth/models/email_input.dart';
import 'package:betchya_frontend/features/auth/models/password_input.dart';
import 'package:betchya_frontend/features/auth/models/dob_input.dart';

class SignUpFormState {
  final EmailInput email;
  final PasswordInput password;
  final DOBInput dob;
  final FormzStatus status;

  SignUpFormState({
    this.email = const EmailInput.pure(),
    this.password = const PasswordInput.pure(),
    this.dob = const DOBInput.pure(),
    this.status = FormzStatus.pure,
  });

  SignUpFormState copyWith({
    EmailInput? email,
    PasswordInput? password,
    DOBInput? dob,
    FormzStatus? status,
  }) {
    return SignUpFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      dob: dob ?? this.dob,
      status: status ?? this.status,
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  final _passwordController = TextEditingController();

  late SignUpFormState formState;

  @override
  void initState() {
    super.initState();
    formState = SignUpFormState();
    _emailController.addListener(() {
      final email = EmailInput.dirty(_emailController.text);
      setState(() {
        formState = formState.copyWith(
          email: email,
          status: Formz.validate([email, formState.password, formState.dob]),
        );
      });
    });
    _dobController.addListener(() {
      final dob = DOBInput.dirty(_dobController.text);
      setState(() {
        formState = formState.copyWith(
          dob: dob,
          status: Formz.validate([formState.email, formState.password, dob]),
        );
      });
    });
    _passwordController.addListener(() {
      final password = PasswordInput.dirty(_passwordController.text);
      setState(() {
        formState = formState.copyWith(
          password: password,
          status: Formz.validate([formState.email, password, formState.dob]),
        );
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _dobController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Email',
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
              controller: _dobController,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Date of Birth (mm/dd/yyyy)',
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
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Password',
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
              '8 or more characters\nAt least 1 capital letter, number & special character',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: formState.status.isValidated
                      ? const Color(0xFF1DD6C1)
                      : const Color(0x801DD6C1),
                  disabledBackgroundColor: const Color(0x801DD6C1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: formState.status.isValidated
                    ? () {
                        // TODO: Implement sign up logic
                      }
                    : null,
                child: const Text(
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

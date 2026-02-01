import 'package:auth_repository/auth_repository.dart';
import 'package:betchya_frontend/src/features/auth/presentation/signup/cubit/sign_up_cubit.dart';
import 'package:betchya_frontend/src/features/auth/presentation/signup/cubit/sign_up_state.dart';
import 'package:betchya_frontend/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(context.read<AuthRepository>()),
      child: const SignUpView(),
    );
  }
}

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.status == FormzSubmissionStatus.success) {
          // Navigation is handled by AppRouter listening to AuthBloc.
          // In this architecture, AuthBloc usually handles key auth state
          // changes. However, SignUp might not auto-login depending on
          // implementation. If Supabase signs in immediately, AuthBloc will
          // see it and redirect. For now, assuming standard flow where auth
          // state change handles it.
        }
        if (state.status == FormzSubmissionStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'Authentication Failure',
                ),
              ),
            );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF22124B),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.goNamed(AppRoute.login.name),
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
              _FullNameInput(),
              const SizedBox(height: 12),
              _EmailInput(),
              const SizedBox(height: 12),
              _PasswordInput(),
              const SizedBox(height: 12),
              _ConfirmPasswordInput(),
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
              _ConsentCheckbox(),
              const SizedBox(height: 12),
              _SignUpButton(),
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
                  _SocialButton(
                    asset: 'assets/icons/google.svg',
                    key: Key('social_button_google'),
                  ),
                  _SocialButton(
                    asset: 'assets/icons/apple.svg',
                    key: Key('social_button_apple'),
                  ),
                  _SocialButton(
                    asset: 'assets/icons/facebook.svg',
                    key: Key('social_button_facebook'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FullNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.fullName != current.fullName,
      builder: (context, state) {
        return TextField(
          key: const Key('signup_full_name_field'),
          onChanged: (value) =>
              context.read<SignUpCubit>().fullNameChanged(value),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Full Name',
            errorText: state.fullName.isPure || state.fullName.isValid
                ? null
                : 'Invalid name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('signup_email_field'),
          onChanged: (value) => context.read<SignUpCubit>().emailChanged(value),
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
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('signup_password_field'),
          onChanged: (value) =>
              context.read<SignUpCubit>().passwordChanged(value),
          obscureText: true,
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
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
        );
      },
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
          previous.confirmPassword != current.confirmPassword,
      builder: (context, state) {
        return TextField(
          key: const Key('signup_confirm_password_field'),
          onChanged: (value) =>
              context.read<SignUpCubit>().confirmPasswordChanged(value),
          obscureText: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Confirm Password',
            errorText:
                state.confirmPassword.isPure || state.confirmPassword.isValid
                    ? null
                    : 'Passwords do not match',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
        );
      },
    );
  }
}

class _ConsentCheckbox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.consent != current.consent,
      builder: (context, state) {
        return Row(
          children: [
            Checkbox(
              value: state.consent,
              onChanged: (value) => context
                  .read<SignUpCubit>()
                  .consentChanged(value: value ?? false),
              activeColor: const Color(0xFF1DD6C1),
            ),
            const Expanded(
              child: Text(
                'I want to receive emails about {organization name}, '
                'feature updates, events, and marketing promotions.',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            key: const Key('signup_button'),
            onPressed: state.isValid
                ? () => context.read<SignUpCubit>().signUpFormSubmitted()
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: state.isValid
                  ? const Color(0xFF1DD6C1)
                  : const Color(0x801DD6C1),
              disabledBackgroundColor: const Color(0x801DD6C1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: state.status == FormzSubmissionStatus.inProgress
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
        );
      },
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.asset, super.key});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO(josh-sanford): Implement social sign up
        debugPrint('Tapped social sign up: $asset');
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

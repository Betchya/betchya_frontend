import 'package:auth_repository/auth_repository.dart';
import 'package:betchya_frontend/src/features/auth/presentation/login/cubit/forgot_login_cubit.dart';
import 'package:betchya_frontend/src/features/auth/presentation/login/cubit/forgot_login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Remove all non-digit characters
    final digitsOnly = text.replaceAll(RegExp(r'[^\d]'), '');

    // Limit to 8 digits (MMDDYYYY)
    final limitedDigits =
        digitsOnly.length > 8 ? digitsOnly.substring(0, 8) : digitsOnly;

    // Format with slashes based on length to avoid confusing intermediate
    // states
    String formatted;
    if (limitedDigits.isEmpty) {
      formatted = '';
    } else if (limitedDigits.length <= 2) {
      // Up to 2 digits: just show month, no trailing slash yet (e.g., "1")
      formatted = limitedDigits;
    } else if (limitedDigits.length <= 4) {
      // 3–4 digits: MM/D or MM/DD
      formatted =
          '${limitedDigits.substring(0, 2)}/${limitedDigits.substring(2)}';
    } else {
      // 5–8 digits: MM/DD/YYYY...
      formatted =
          '${limitedDigits.substring(0, 2)}/${limitedDigits.substring(2, 4)}/'
          '${limitedDigits.substring(4)}';
    }

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class ForgotLoginInfoScreen extends StatelessWidget {
  const ForgotLoginInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotLoginCubit(context.read<AuthRepository>()),
      child: const ForgotLoginInfoView(),
    );
  }
}

class ForgotLoginInfoView extends StatelessWidget {
  const ForgotLoginInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotLoginCubit, ForgotLoginState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == FormzSubmissionStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Authentication Failure'),
              ),
            );
        }
        if (state.status == FormzSubmissionStatus.success) {
          // Use a root navigator or ensure context is valid if popping
          if (context.mounted) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text(
                    'Password reset email sent! Check your inbox.',
                  ),
                ),
              );
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            key: const Key('forgot_login_appbar_back_button'),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: Center(
            child: GestureDetector(
              key: const Key('forgot_login_gesture_detector'),
              behavior: HitTestBehavior.opaque,
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity != null &&
                    details.primaryVelocity! > 0) {
                  Navigator.of(context).pop();
                }
              },
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: _ForgotLoginContent(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ForgotLoginContent extends StatefulWidget {
  @override
  State<_ForgotLoginContent> createState() => _ForgotLoginContentState();
}

class _ForgotLoginContentState extends State<_ForgotLoginContent> {
  final _dobController = TextEditingController();

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (!context.mounted) return;
      final formattedDate = '${picked.month.toString().padLeft(2, '0')}/'
          '${picked.day.toString().padLeft(2, '0')}/${picked.year}';
      _dobController.text = formattedDate;
      context.read<ForgotLoginCubit>().dobChanged(formattedDate);
    }
  }

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
        _DobInput(
          controller: _dobController,
          onShowDatePicker: () => _showDatePicker(context),
        ),
        const SizedBox(height: 24),
        _SubmitButton(),
        const SizedBox(height: 24),
        // Back to Login
        GestureDetector(
          key: const Key('forgot_login_bottom_back_button'),
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Back to Login',
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

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotLoginCubit, ForgotLoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('forgot_login_email_field'),
          onChanged: (value) =>
              context.read<ForgotLoginCubit>().emailChanged(value),
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

class _DobInput extends StatelessWidget {
  const _DobInput({
    required this.controller,
    required this.onShowDatePicker,
  });

  final TextEditingController controller;
  final VoidCallback onShowDatePicker;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotLoginCubit, ForgotLoginState>(
      builder: (context, state) {
        return TextField(
          key: const Key('forgot_login_dob_field'),
          controller: controller,
          onChanged: (value) =>
              context.read<ForgotLoginCubit>().dobChanged(value),
          keyboardType: TextInputType.datetime,
          obscureText: state.dobObscured,
          inputFormatters: [DateInputFormatter()],
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Date of Birth (mm/dd/yyyy)',
            errorText: state.dob.isPure || state.dob.isValid
                ? null
                : 'Invalid date of birth',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: onShowDatePicker,
                  icon: const Icon(Icons.calendar_today, color: Colors.grey),
                ),
                TextButton(
                  onPressed: () =>
                      context.read<ForgotLoginCubit>().toggleDobObscured(),
                  child: Text(
                    state.dobObscured ? 'Show' : 'Hide',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotLoginCubit, ForgotLoginState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            key: const Key('forgot_login_submit_button'),
            onPressed: state.isValid
                ? () => context.read<ForgotLoginCubit>().submit()
                : null,
            child: state.status == FormzSubmissionStatus.inProgress
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    'Submit',
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

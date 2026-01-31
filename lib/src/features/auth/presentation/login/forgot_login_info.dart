import 'package:betchya_frontend/src/features/auth/presentation/login/forgot_login_info_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    // Format with slashes
    var formatted = '';
    if (limitedDigits.isNotEmpty) {
      formatted = limitedDigits.substring(0, 1);
    }
    if (limitedDigits.length >= 2) {
      formatted = '${limitedDigits.substring(0, 2)}/';
    }
    if (limitedDigits.length >= 3) {
      formatted =
          '${limitedDigits.substring(0, 2)}/${limitedDigits.substring(2, 3)}';
    }
    if (limitedDigits.length >= 4) {
      formatted =
          '${limitedDigits.substring(0, 2)}/${limitedDigits.substring(2, 4)}/';
    }
    if (limitedDigits.length >= 5) {
      formatted =
          '${limitedDigits.substring(0, 2)}/${limitedDigits.substring(2, 4)}/${limitedDigits.substring(4)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class ForgotLoginInfoScreen extends ConsumerWidget {
  const ForgotLoginInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF22124B),
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
                            child: SingleChildScrollView(              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: _ForgotLoginInfoScreenContent(),
            ),
          ),
        ),
      ),
    );
  }
}

class _ForgotLoginInfoScreenContent extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ForgotLoginInfoScreenContent> createState() =>
      _ForgotLoginInfoScreenContentState();
}

class _ForgotLoginInfoScreenContentState
    extends ConsumerState<_ForgotLoginInfoScreenContent> {
  final _dobController = TextEditingController();

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _showDatePicker(
    BuildContext context,
    ForgotLoginInfoController controller,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now()
          .subtract(const Duration(days: 365 * 25)), // Default to 25 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now()
          .subtract(const Duration(days: 365 * 18)), // Minimum 18 years old
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1DD6C1),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedDate =
          '${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}';
      _dobController.text = formattedDate;
      controller.dobChanged(formattedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(forgotLoginInfoControllerProvider);
    final formController = ref.read(forgotLoginInfoControllerProvider.notifier);
    final submissionState = ref.watch(forgotLoginInfoSubmissionStateProvider);

    // Listen for success state
    ref.listen(forgotLoginInfoSubmissionStateProvider, (previous, next) {
      if (next?.hasValue ?? false) {
        // Show success message and navigate back
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login information has been sent to your email'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    });

    if (_dobController.text != formState.dob.value) {
      _dobController.text = formState.dob.value;
    }

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
          key: const Key('forgot_login_email_field'),
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
        // Date of Birth
        TextField(
          key: const Key('forgot_login_dob_field'),
          controller: _dobController,
          onChanged: formController.dobChanged,
          keyboardType: TextInputType.number,
          obscureText: formState.dobObscured,
          inputFormatters: [DateInputFormatter()],
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Date of Birth (mm/dd/yyyy)',
            errorText: formState.dob.invalid ? 'Invalid date of birth' : null,
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
                  onPressed: () => _showDatePicker(context, formController),
                  icon: const Icon(Icons.calendar_today, color: Colors.grey),
                ),
                TextButton(
                  onPressed: formController.toggleDobObscured,
                  child: Text(
                    formState.dobObscured ? 'Show' : 'Hide',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Submit Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            key: const Key('forgot_login_submit_button'),
            style: ElevatedButton.styleFrom(
              backgroundColor: formState.status == FormzStatus.valid &&
                      (submissionState?.isLoading ?? false) != true
                  ? const Color(0xFF1DD6C1)
                  : const Color(0x801DD6C1),
              disabledBackgroundColor: const Color(0x801DD6C1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: formState.status == FormzStatus.valid &&
                    (submissionState?.isLoading ?? false) != true
                ? () async {
                    formController.validateAll();
                    if (formState.status == FormzStatus.valid) {
                      // Set loading state
                      ref
                          .read(forgotLoginInfoSubmissionStateProvider.notifier)
                          .state = const AsyncValue.loading();

                      try {
                        await formController.submit();
                        // Set success state
                        ref
                            .read(
                              forgotLoginInfoSubmissionStateProvider.notifier,
                            )
                            .state = const AsyncValue.data(null);
                      } catch (e) {
                        // Set error state
                        ref
                            .read(
                              forgotLoginInfoSubmissionStateProvider.notifier,
                            )
                            .state = AsyncValue.error(e, StackTrace.current);
                      }
                    }
                  }
                : null,
            child: (submissionState?.isLoading ?? false)
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
          ),
        ),
        if (submissionState?.hasError ?? false) ...[
          const SizedBox(height: 12),
          Text(
            submissionState!.error.toString(),
            style: const TextStyle(color: Colors.red),
          ),
        ],
        const SizedBox(height: 24),
        // Back to Login
        GestureDetector(
          key: const Key('forgot_login_back_button'),
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

import 'package:betchya_frontend/features/auth/models/dob_input.dart';
import 'package:betchya_frontend/features/auth/models/email_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';

class ForgotLoginInfoState {
  const ForgotLoginInfoState({
    this.email = const EmailInput.pure(),
    this.dob = const DOBInput.pure(),
    this.status = FormzStatus.pure,
    this.error,
    this.isSubmitting = false,
    this.dobObscured = true,
  });

  final EmailInput email;
  final DOBInput dob;
  final FormzStatus status;
  final String? error;
  final bool isSubmitting;
  final bool dobObscured;

  ForgotLoginInfoState copyWith({
    EmailInput? email,
    DOBInput? dob,
    FormzStatus? status,
    String? error,
    bool? isSubmitting,
    bool? dobObscured,
  }) {
    return ForgotLoginInfoState(
      email: email ?? this.email,
      dob: dob ?? this.dob,
      status: status ?? this.status,
      error: error,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      dobObscured: dobObscured ?? this.dobObscured,
    );
  }
}

class ForgotLoginInfoController extends StateNotifier<ForgotLoginInfoState> {
  ForgotLoginInfoController() : super(const ForgotLoginInfoState());

  void emailChanged(String value) {
    final email = EmailInput.dirty(value);
    state = state.copyWith(
      email: email,
      status: Formz.validate([email, state.dob]),
    );
  }

  void dobChanged(String value) {
    final dob = DOBInput.dirty(value);
    state = state.copyWith(
      dob: dob,
      status: Formz.validate([state.email, dob]),
    );
  }

  void toggleDobObscured() {
    state = state.copyWith(dobObscured: !state.dobObscured);
  }

  Future<void> submit() async {
    if (state.status != FormzStatus.valid) return;
    state = state.copyWith(isSubmitting: true);
    // Simulate a network call
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(isSubmitting: false);
    // TODO: Implement actual forgot login info logic
  }
}

final forgotLoginInfoControllerProvider = StateNotifierProvider.autoDispose<ForgotLoginInfoController, ForgotLoginInfoState>((ref) {
  return ForgotLoginInfoController();
});

class ForgotLoginInfoScreen extends ConsumerStatefulWidget {
  const ForgotLoginInfoScreen({super.key});

  @override
  ConsumerState<ForgotLoginInfoScreen> createState() => _ForgotLoginInfoScreenState();
}

class _ForgotLoginInfoScreenState extends ConsumerState<ForgotLoginInfoScreen> {
  final _dobController = TextEditingController();

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forgotLoginInfoControllerProvider);
    final controller = ref.read(forgotLoginInfoControllerProvider.notifier);
    if (_dobController.text != state.dob.value) {
      _dobController.text = state.dob.value;
    }
    return Scaffold(
      backgroundColor: const Color(0xFF22124B),
      body: SafeArea(
        child: Center(
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
                Navigator.of(context).pop();
              }
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 80),
                    child: SvgPicture.asset(
                      'assets/images/betchya_logo_white.svg',
                      height: 100,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 56),
                    child: TextField(
                      onChanged: controller.emailChanged,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Email',
                        hintStyle: const TextStyle(color: Colors.grey),
                        errorText: state.email.invalid ? 'Invalid email' : null,
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
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 12),
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        TextField(
                          controller: _dobController,
                          onChanged: controller.dobChanged,
                          keyboardType: TextInputType.datetime,
                          obscureText: state.dobObscured,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Date of Birth (mm/dd/yyyy)',
                            hintStyle: const TextStyle(color: Colors.grey),
                            errorText: state.dob.invalid ? 'Invalid date of birth' : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                            suffixIcon: TextButton(
                              onPressed: controller.toggleDobObscured,
                              child: Text(
                                state.dobObscured ? 'Show' : 'Hide',
                                style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 24),
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: state.status == FormzStatus.valid && !state.isSubmitting
                            ? const Color(0xFF1DD6C1)
                            : const Color(0x801DD6C1),
                        disabledBackgroundColor: const Color(0x801DD6C1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: state.status == FormzStatus.valid && !state.isSubmitting
                          ? controller.submit
                          : null,
                      child: state.isSubmitting
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
                  if (state.error != null)
                    Container(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        state.error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.only(top: 24),
                    child: GestureDetector(
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

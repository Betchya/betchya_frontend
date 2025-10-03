import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:betchya_frontend/src/features/auth/presentation/login/forgot_login_info_controller.dart';


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

import 'package:formz/formz.dart';

/// Validation logic for confirm password field.
class ConfirmPasswordInput extends FormzInput<String, String> {
  const ConfirmPasswordInput.pure({this.password = ''}) : super.pure('');
  const ConfirmPasswordInput.dirty({required this.password, String value = ''})
      : super.dirty(value);

  final String password;

  @override
  String? validator(String value) {
    return value.isEmpty || value != password ? 'Passwords do not match' : null;
  }
}

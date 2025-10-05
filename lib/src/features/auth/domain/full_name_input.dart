// ignore_for_file: use_super_parameters

import 'package:formz/formz.dart';

enum FullNameValidationError { empty }

class FullNameInput extends FormzInput<String, FullNameValidationError> {
  const FullNameInput.pure() : super.pure('');
  const FullNameInput.dirty([String value = '']) : super.dirty(value);

  @override
  FullNameValidationError? validator(String value) {
    return value.trim().isEmpty ? FullNameValidationError.empty : null;
  }
}

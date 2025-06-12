import 'package:flutter_core/lib/core/cubits/base_form_cubit.dart';
// Assuming BaseFormFieldState and FieldValidator are also from flutter-core.
// If not, these imports might need adjustment by the user.
// For example:
import 'package:flutter_core/lib/core/models/base_form_field_state.dart'; // Hypothetical path
import 'package:flutter_core/lib/core/validation/field_validator.dart'; // Hypothetical path


class LoginPageCubit extends BaseFormCubit {
  static const String emailKey = 'email';
  static const String passwordKey = 'password';

  // Store validators map for the getter
  final Map<String, FieldValidator> _fieldValidators = {
    emailKey: (value, _) {
      if (value == null || value.toString().isEmpty) return "Email required";
      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
      if (!emailRegex.hasMatch(value.toString())) return "Enter valid email";
      return null;
    },
    passwordKey: (value, _) {
      if (value == null || value.toString().isEmpty) return "Password required";
      if (value.toString().length < 6) return "Min 6 characters";
      return null;
    },
  };

  LoginPageCubit() : super() { // Assumes BaseFormCubit has a no-arg constructor
    // Initialize fields. Assumes initializeFormFields is a method in BaseFormCubit.
    initializeFormFields({
      emailKey: const BaseFormFieldState(value: '', initialValue: ''),
      passwordKey: const BaseFormFieldState(value: '', initialValue: ''),
    });
  }

  @override
  Map<String, FieldValidator> get validators => _fieldValidators;

  @override
  Future<void> submitForm(Map<String, dynamic> values) async {
    // BaseFormCubit's submit() method likely sets isSubmitting to true
    // and calls this method.

    // Clear previous apiError and set isFailure/isSuccess to false if needed.
    // This might already be handled by BaseFormCubit's submit method.
    // However, explicitly managing it here ensures clean state for new submission.
    if (state.isFailure || state.apiError != null || state.isSuccess) {
       emit(state.copyWith(isFailure: false, apiError: null, isSuccess: false));
    }
    // isSubmitting is typically handled by the base class calling this method.
    // If not, one might call emit(state.copyWith(isSubmitting: true)); here.

    await Future.delayed(const Duration(seconds: 1)); // Reduced delay for faster testing

    try {
      final email = values[emailKey];
      final password = values[passwordKey];

      print("LoginPageCubit: Logging in with Email: $email, Password: $password");

      // Simulate a successful login for now
      if (email == 'test@example.com' && password == 'password') {
        print("LoginPageCubit: Login success simulated.");
        emit(state.copyWith(isSubmitting: false, isSuccess: true));
      } else {
        print("LoginPageCubit: Login failed simulated (invalid credentials).");
        emit(state.copyWith(isSubmitting: false, isFailure: true, apiError: "Invalid credentials."));
      }

    } catch (e) {
      print("LoginPageCubit: Login error: ${e.toString()}");
      emit(state.copyWith(
        isSubmitting: false,
        isFailure: true,
        apiError: "Login failed due to an unexpected error. Please try again. Details: ${e.toString()}",
      ));
    }
  }
}

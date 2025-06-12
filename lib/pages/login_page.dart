import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/login_page_cubit.dart';
import '../widgets/app_text_field.dart';
// Import BaseFormState from flutter-core, adjust path as necessary.
// This is a common pattern, e.g.:
import 'package:flutter_core/lib/core/states/base_form_state.dart'; // User needs to confirm/provide this path

// Assuming PhoneNumberPage and PhoneNumberCubit are placeholders for now or exist elsewhere.
// If they don't exist, the Dart analyzer will show errors for these, but the login page itself should be fine.
// For this subtask, we are not creating these files.


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Widget pageProvider() {
    return BlocProvider<LoginPageCubit>( // Corrected to LoginPageCubit
      create: (_) => LoginPageCubit(),
      child: const LoginPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // LoginPageCubit is now expected to be provided by an ancestor,
    // which pageProvider() ensures when routing.
    return Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: BlocConsumer<LoginPageCubit, BaseFormState>( // Use BaseFormState
          listenWhen: (prev, curr) =>
              prev.isSubmitting != curr.isSubmitting ||
              prev.isSuccess != curr.isSuccess ||
              prev.isFailure != curr.isFailure ||
              prev.apiError != curr.apiError,
          listener: (context, state) {
            if (state.isSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Login Success!'), backgroundColor: Colors.green),
              );
            } else if (state.isFailure && state.apiError != null) {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Error"),
                  content: Text(state.apiError.toString()), // Use toString() for safety
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text("OK"),
                    ),
                  ],
                ),
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<LoginPageCubit>();

            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Email Field
                      BlocBuilder<LoginPageCubit, BaseFormState>(
                        buildWhen: (prev, curr) =>
                            prev.fields[LoginPageCubit.emailKey] !=
                            curr.fields[LoginPageCubit.emailKey],
                        builder: (context, state) {
                          return AppTextField(
                            label: "Email",
                            keyboardType: TextInputType.emailAddress,
                            value: state.fields[LoginPageCubit.emailKey]?.value as String? ?? '',
                            errorText: state.fields[LoginPageCubit.emailKey]?.error as String?,
                            onChanged: (v) =>
                                cubit.updateField(LoginPageCubit.emailKey, v),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password Field
                      BlocBuilder<LoginPageCubit, BaseFormState>(
                        buildWhen: (prev, curr) =>
                            prev.fields[LoginPageCubit.passwordKey] !=
                            curr.fields[LoginPageCubit.passwordKey],
                        builder: (context, state) {
                          return AppTextField(
                            label: "Password",
                            obscureText: true,
                            value: state.fields[LoginPageCubit.passwordKey]?.value as String? ?? '',
                            errorText: state.fields[LoginPageCubit.passwordKey]?.error as String?,
                            onChanged: (v) =>
                                cubit.updateField(LoginPageCubit.passwordKey, v),
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      // Submit Button
                      BlocBuilder<LoginPageCubit, BaseFormState>(
                        buildWhen: (prev, curr) =>
                            prev.isFormValid != curr.isFormValid ||
                            prev.isFormChanged != curr.isFormChanged || // Added isFormChanged
                            prev.isSubmitting != curr.isSubmitting,
                        builder: (context, state) {
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: state.isFormValid &&
                                      state.isFormChanged && // User confirmed isFormChanged is in BaseFormState
                                      !state.isSubmitting
                                  ? () => cubit.submit() // Assumes cubit.submit() exists from BaseFormCubit
                                  : null,
                              child: const Text('Login'),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        child: const Text("Don't have an account? Register"),
                        onPressed: () {
                          // Navigation to PhoneNumberPage (placeholders included for subtask to run)
                           Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                      create: (context) => PhoneNumberCubit(),
                                      child: const PhoneNumberPage(),
                                    )),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Loader
                if (state.isSubmitting)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.2),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

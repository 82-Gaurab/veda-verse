import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/app/routes/app_routes.dart';
import 'package:vedaverse/app/theme/app_colors.dart';
import 'package:vedaverse/common/my_snack_bar.dart';
import 'package:vedaverse/features/auth/presentation/pages/login_screen.dart';
import 'package:vedaverse/features/auth/presentation/widgets/password_field.dart';
import 'package:vedaverse/features/reset-password/presentation/state/reset_password_state.dart';
import 'package:vedaverse/features/reset-password/presentation/view_model/reset_password_view_model.dart';

class ResetPassword extends ConsumerStatefulWidget {
  final String email;
  const ResetPassword({super.key, required this.email});

  @override
  ConsumerState<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends ConsumerState<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> _handleChangePassword() async {
    if (_formKey.currentState!.validate()) {
      ref
          .read(resetPasswordViewModelProvider.notifier)
          .resetPassword(
            email: widget.email,
            newPassword: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final resetPasswordState = ref.watch(resetPasswordViewModelProvider);
    ref.listen(resetPasswordViewModelProvider, (previous, next) {
      if (next.status == ResetStatus.error) {
        SnackbarUtils.showError(
          context,
          next.errorMessage ?? "Password Reset Failed",
        );
      } else if (next.status == ResetStatus.success) {
        SnackbarUtils.showSuccess(context, "Password Reset Successfully");
        AppRoutes.pushReplacement(context, const LoginScreen());
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
        centerTitle: true,
        leading: Container(),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                PasswordField(
                  controller: _passwordController,
                  labelText: 'Password',
                  hintText: 'Create a strong password',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                PasswordField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirm Password',
                  hintText: 'Re-enter your password',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                SizedBox(
                  height: 56,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: resetPasswordState.status == ResetStatus.loading
                        ? null
                        : _handleChangePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: resetPasswordState.status == ResetStatus.loading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Reset Password',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

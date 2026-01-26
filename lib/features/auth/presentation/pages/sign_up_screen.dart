import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/app/theme/app_colors.dart';
import 'package:vedaverse/app/theme/theme_extensions.dart';
import 'package:vedaverse/common/my_snack_bar.dart';
import 'package:vedaverse/features/auth/presentation/state/auth_state.dart';
import 'package:vedaverse/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:vedaverse/features/auth/presentation/widgets/auth_header.dart';
import 'package:vedaverse/features/auth/presentation/widgets/password_field.dart';
import 'package:vedaverse/features/auth/presentation/widgets/terms_checkbox.dart';
import 'package:vedaverse/features/onboarding/presentation/pages/first_on_boarding_screen.dart';
import 'package:vedaverse/core/widgets/my_input_form_field.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _agreedToTerms = false;

  Future<void> _handleSignUp() async {
    if (!_agreedToTerms) {
      SnackbarUtils.showError(
        context,
        'Please agree to the Terms & Conditions',
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FirstOnBoardingScreen(
            firstName: _firstNameController.text,
            email: _emailController.text,
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
            username: _emailController.text.trim().split("@").first,
            lastName: _lastNameController.text,
          ),
        ),
      );
    }
  }

  void _navigateToLogin() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: context.softShadow,
            ),
            child: Icon(Icons.arrow_back, color: context.textPrimary, size: 20),
          ),
          onPressed: _navigateToLogin,
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Padding(
              padding: EdgeInsets.all(15),
              child: Form(
                key: _formKey,

                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(height: 30),

                          // MyProgressBar(notProgressFlex: 7),

                          // SizedBox(height: 50),
                          const AuthHeader(
                            icon: Icons.person_add_rounded,
                            title: 'Join Us Today',
                            subtitle: 'Create your account to get started',
                          ),

                          SizedBox(height: 50),

                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _firstNameController,
                                  decoration: InputDecoration(
                                    labelText: "First Name",
                                    prefixIcon: Icon(Icons.person),
                                  ),
                                ),
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: TextFormField(
                                  controller: _lastNameController,
                                  decoration: InputDecoration(
                                    labelText: "Last Name",
                                    prefixIcon: Icon(Icons.person),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),

                          MyInputFormField(
                            controller: _emailController,
                            labelText: "Email",
                            inputType: TextInputType.emailAddress,
                            icon: Icon(Icons.email),
                          ),
                          SizedBox(height: 15),
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

                          SizedBox(height: 20),

                          TermsCheckbox(
                            value: _agreedToTerms,
                            onChanged: (value) =>
                                setState(() => _agreedToTerms = value),
                          ),
                          Spacer(),

                          SizedBox(
                            height: 56,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: authState.status == AuthStatus.loading
                                  ? null
                                  : _handleSignUp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: authState.status == AuthStatus.loading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : const Text(
                                      'Sign Up',
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
              ),
            );
          },
        ),
      ),
    );
  }
}

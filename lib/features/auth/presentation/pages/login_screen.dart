import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/app/routes/app_routes.dart';
import 'package:vedaverse/app/theme/app_colors.dart';
import 'package:vedaverse/common/my_snack_bar.dart';
import 'package:vedaverse/features/auth/presentation/state/auth_state.dart';
import 'package:vedaverse/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:vedaverse/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:vedaverse/features/auth/presentation/pages/sign_up_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      ref
          .read(authViewModelProvider.notifier)
          .login(
            email: _emailController.text,
            password: _passwordController.text,
          );
    }
  }

  void _navigateToSignup() => AppRoutes.push(context, const SignUpScreen());
  void _handleForgotPassword() =>
      SnackbarUtils.showInfo(context, 'Forgot password feature coming soon');
  void _handleGoogleSignIn() =>
      SnackbarUtils.showInfo(context, 'Google Sign In coming soon');

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    ref.listen(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.error) {
        SnackbarUtils.showError(context, next.errorMessage ?? "Login Failed");
      } else if (next.status == AuthStatus.authenticated) {
        SnackbarUtils.showSuccess(context, "Login Successful");
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => DashboardScreen()));
      }
    });

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Center(
                            child: Image.asset(
                              'assets/icons/logo.png',
                              width: 200,
                              height: 70,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome Back",
                                style: TextStyle(
                                  fontSize: 35,
                                  color: AppColors.accent1,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Sign in to Continue",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 5),

                          Column(
                            children: [
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: "Email",
                                  prefixIcon: Icon(Icons.email),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(height: 15),

                              TextFormField(
                                obscureText: _obscurePassword,
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.key),
                                  labelText: "Password",
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                    ),
                                    onPressed: () => setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                              GestureDetector(
                                onTap: _handleForgotPassword,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.red.shade400,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 10),
                            ],
                          ),

                          SizedBox(
                            height: 56,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: authState.status == AuthStatus.loading
                                  ? null
                                  : _handleLogin,
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
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          Row(
                            children: [
                              const Expanded(child: Divider()),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  'OR',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const Expanded(child: Divider()),
                            ],
                          ),
                          Text(
                            'Sign in With',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),

                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: _handleGoogleSignIn,
                                  icon: SvgPicture.asset(
                                    'assets/icons/google_logo.svg',
                                    width: 20,
                                    height: 20,
                                  ),
                                  label: const Text(
                                    'Google',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an Account? ",
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 15,
                                ),
                              ),
                              GestureDetector(
                                onTap: _navigateToSignup,
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
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

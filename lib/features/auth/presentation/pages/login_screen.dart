import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/common/my_snack_bar.dart';
import 'package:vedaverse/features/auth/presentation/state/auth_state.dart';
import 'package:vedaverse/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:vedaverse/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:vedaverse/features/auth/presentation/pages/sign_up_screen.dart';
import 'package:vedaverse/core/widgets/my_button.dart';
import 'package:vedaverse/core/widgets/my_input_form_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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

  @override
  Widget build(BuildContext context) {
    ref.listen(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.error) {
        showMySnackBar(
          context: context,
          message: next.errorMessage ?? "Login Failed",
          color: Colors.redAccent,
        );
      } else if (next.status == AuthStatus.authenticated) {
        showMySnackBar(
          context: context,
          message: "Login Successful",
          color: Colors.green.shade900,
        );
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => DashboardScreen()));
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 35,
                        color: Color(0xFF38B120),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Please fill up email and password to log in to your account",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                Column(
                  children: [
                    MyInputFormField(
                      controller: _emailController,
                      labelText: "Email",
                      inputType: TextInputType.emailAddress,
                      icon: Icon(Icons.email),
                    ),

                    SizedBox(height: 15),

                    MyInputFormField(
                      icon: Icon(Icons.key),
                      obscureText: true,
                      controller: _passwordController,
                      labelText: "Password",
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(
                          Icons.check_box,
                          color: Color(0xFFFFAE37),
                          size: 30,
                        ),
                        SizedBox(width: 10),
                        Text("Remember Me", style: TextStyle(fontSize: 15)),
                        Spacer(),
                        Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.red.shade400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Column(
                  children: [
                    MyButton(text: "Login", onPressed: _handleLogin),

                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 24,
                          color: Color(0xFFFFAE37),
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
    );
  }
}

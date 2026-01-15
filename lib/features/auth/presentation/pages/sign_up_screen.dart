import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:vedaverse/features/onboarding/presentation/pages/first_on_boarding_screen.dart';
import 'package:vedaverse/core/widgets/my_button.dart';
import 'package:vedaverse/core/widgets/my_input_form_field.dart';
import 'package:vedaverse/core/widgets/my_progress_bar.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
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
                          MyProgressBar(notProgressFlex: 7),

                          SizedBox(height: 50),

                          Text(
                            "Create New Account",
                            style: TextStyle(
                              fontSize: 35,
                              color: Color(0xFF38B120),
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            "Enter Username, Email and Password to create new account",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 50),

                          MyInputFormField(
                            controller: _fullNameController,
                            labelText: "Username",
                            icon: Icon(Icons.person),
                          ),
                          SizedBox(height: 15),

                          MyInputFormField(
                            controller: _emailController,
                            labelText: "Email",
                            inputType: TextInputType.emailAddress,
                            icon: Icon(Icons.email),
                          ),
                          SizedBox(height: 15),

                          MyInputFormField(
                            controller: _passwordController,
                            labelText: "Password",
                            obscureText: true,
                            icon: Icon(Icons.key),
                          ),
                          SizedBox(height: 15),

                          MyInputFormField(
                            controller: _confirmPasswordController,
                            labelText: "Confirm Password",
                            obscureText: true,
                            icon: Icon(Icons.key_off),
                          ),

                          SizedBox(height: 15),

                          Row(
                            children: [
                              Icon(
                                Icons.check_box,
                                color: Color(0xFFFFAE37),
                                size: 30,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Remember Me",
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),

                          Spacer(),

                          MyButton(
                            text: "Sign Up",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FirstOnBoardingScreen(
                                      fullName: _fullNameController.text,
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      confirmPassword:
                                          _confirmPasswordController.text,
                                      username: _emailController.text
                                          .trim()
                                          .split("@")
                                          .first,
                                    ),
                                  ),
                                );
                              }
                            },
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

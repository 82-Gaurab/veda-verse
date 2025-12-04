import 'package:flutter/material.dart';
import 'package:vedaverse/common/my_snack_bar.dart';
import 'package:vedaverse/screen/on_boarding_screen.dart';
import 'package:vedaverse/widgets/my_button.dart';
import 'package:vedaverse/widgets/my_input_form_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create an Account",
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFFFAE37),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Form(
          key: _formKey,

          child: Column(
            children: [
              MyInputFormField(
                controller: _userNameController,
                labelText: "Username",
              ),
              SizedBox(height: 20),

              MyInputFormField(
                controller: _emailController,
                labelText: "Email",
                inputType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),

              MyInputFormField(
                controller: _passwordController,
                labelText: "Password",
                obscureText: true,
              ),
              SizedBox(height: 20),

              MyInputFormField(
                controller: _confirmPasswordController,
                labelText: "Confirm Password",
                obscureText: true,
              ),

              SizedBox(height: 20),

              MyButton(
                text: "Sign Up",
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    showMySnackBar(
                      context: context,
                      message: "Successfully created new account",
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OnBoardingScreen(),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

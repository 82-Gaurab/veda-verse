import 'package:flutter/material.dart';
import 'package:vedaverse/common/my_snack_bar.dart';
import 'package:vedaverse/screen/dashboard_screen.dart';
import 'package:vedaverse/screen/sign_up_screen.dart';
import 'package:vedaverse/core/widgets/my_button.dart';
import 'package:vedaverse/core/widgets/my_input_form_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    final _formKey = GlobalKey<FormState>();

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
                    MyButton(
                      text: "Login",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          showMySnackBar(
                            context: context,
                            message: "Login Success",
                          );

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DashboardScreen(),
                            ),
                          );
                        }
                      },
                    ),

                    TextButton(
                      onPressed: () {
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

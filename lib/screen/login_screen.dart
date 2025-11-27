import 'package:flutter/material.dart';
import 'package:vedaverse/common/my_snack_bar.dart';
import 'package:vedaverse/widgets/my_button.dart';
import 'package:vedaverse/widgets/my_input_form_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login Screen",
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFFFAE37),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              MyInputFormField(
                controller: _emailController,
                labelText: "Email",
                inputType: TextInputType.emailAddress,
              ),

              SizedBox(height: 25),
              MyInputFormField(
                obscureText: true,
                controller: _passwordController,
                labelText: "Password",
              ),
              SizedBox(height: 25),

              MyButton(
                text: "Login",
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    showMySnackBar(context: context, message: "Login Success");
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

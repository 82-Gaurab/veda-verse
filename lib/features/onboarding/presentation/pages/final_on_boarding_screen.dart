import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/common/my_snack_bar.dart';
import 'package:vedaverse/features/auth/presentation/pages/login_screen.dart';
import 'package:vedaverse/features/auth/presentation/state/auth_state.dart';
import 'package:vedaverse/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:vedaverse/core/widgets/my_button.dart';
import 'package:vedaverse/core/widgets/my_progress_bar.dart';

class FinalOnBoardingScreen extends ConsumerStatefulWidget {
  final String fullName;
  final String email;
  final String password;
  final String username;

  const FinalOnBoardingScreen({
    super.key,
    required this.fullName,
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  ConsumerState<FinalOnBoardingScreen> createState() =>
      _FinalOnBoardingScreenState();
}

class _FinalOnBoardingScreenState extends ConsumerState<FinalOnBoardingScreen> {
  Future<void> _handleSignup() async {
    // NOTE: Passing the data from here to view model
    ref
        .read(authViewModelProvider.notifier)
        .register(
          fullName: widget.fullName,
          email: widget.email,
          password: widget.password,
          username: widget.username,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.error) {
        showMySnackBar(
          context: context,
          message: next.errorMessage ?? "Registration failed",
        );
      } else if (next.status == AuthStatus.register) {
        showMySnackBar(context: context, message: "Registration successful");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });

    List<String> genreList = [
      "Romance",
      "Fantasy",
      "Sci-Fi",
      "Horror",
      "Mystery",
      "Thriller",
      "Psychology",
      "Inspirational",
      "Comedy",
      "Action",
      "Adventure",
      "Comics",
      "Children's",
      "Art & Photography",
      "Food & Drinks",
      "Biography",
      "Science & Technology",
      "Guide/ How-to",
      "Travel",
    ];

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 13),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        SizedBox(height: 30),
                        MyProgressBar(notProgressFlex: 0),
                        SizedBox(height: 50),
                        Text(
                          "Choose The Book Genre You Like",
                          style: TextStyle(
                            fontSize: 35,
                            color: Color(0xFF38B120),
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 30),
                        Wrap(
                          spacing: 13,
                          runSpacing: 20,
                          children: genreList
                              .map(
                                (ele) => Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 30,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color(0xFFFFAE37),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),

                                  // color: const Color.fromARGB(255, 129, 176, 214),
                                  child: Text(
                                    ele,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              )
                              .toList(),
                        ),

                        Spacer(),

                        MyButton(text: "Continue", onPressed: _handleSignup),
                      ],
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

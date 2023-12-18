import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internal_tool/pages/home.dart';
import 'package:internal_tool/widgets/appbar.dart';
import 'package:internal_tool/widgets/buttons.dart';
import 'package:internal_tool/widgets/colors.dart';
import 'package:internal_tool/widgets/snackbars.dart';
import 'package:internal_tool/widgets/textfields.dart';
import 'package:internal_tool/widgets/transitions.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //bool
  bool _loading = false;

  login() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      )
          .onError((FirebaseException error, stackTrace) {
        if (error.code == 'user-not-found') {
          return errorSnackbar(context, 'No user found for that email');
        } else if (error.code.toString() == 'wrong-password') {
          return errorSnackbar(context, 'Wrong password');
        } else if (error.code.toString() == 'network-request-fail') {
          return errorSnackbar(context, 'Please check your internet');
        } else if (error.code.toString() == 'invalid-credentials') {
          errorSnackbar(context, 'Join the waitlist');
        } else if (error.code.toString() == 'wrong-password') {
          errorSnackbar(context, 'Wrong password');
        }
        return errorSnackbar(context, error.code.toString());
      }).then((value) {
        Navigator.popUntil(context, (route) => false);
        mainSlideTransition(context, const BotNavBar(), (then) {});
      });
    } on FirebaseAuthException catch (e) {
      errorSnackbar(context, e.message.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBlack,
      appBar: customAppBar("Login"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Column(
          children: [
            const SizedBox(height: 25),
            emailTextField(context, "Email", emailController),
            const SizedBox(height: 20),
            passwordTextField(context, passwordController, () => null),
            const Expanded(child: SizedBox(height: 25)),
            b1Button(
              "Login",
              () async {
                setState(() {
                  _loading = true;
                });
                if (emailController.text.contains('@') &&
                    passwordController.text.length >= 6) {
                  FocusManager.instance.primaryFocus?.unfocus();

                  login();
                } else if (!emailController.text.contains('@')) {
                  await errorSnackbar(context, 'Please enter correct email');
                } else if (passwordController.text.length < 6) {
                  errorSnackbar(context, 'Password must be atlease 6 digits');
                } else {
                  errorSnackbar(
                      context, "Please check your email and password");
                }
                setState(() {
                  _loading = false;
                });
              },
            ),
            TextButton(
              onPressed: () {
                successSnackbar(context, 'Coming soon');
              },
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Text(
                      'Join Waitlist',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(color: darkGrey),
                    ),
            )
          ],
        ),
      ),
    );
  }
}

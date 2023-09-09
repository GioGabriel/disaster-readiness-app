import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'register_page.dart';
import 'landing_page.dart';

class LoginPage extends StatelessWidget {
  static const String loginPage = '/login';
  DateTime? lastBackPressedTime;

  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    void _signInWithEmailAndPassword(BuildContext context) async {
      String email = emailController.text.trim();
      String password = passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        Fluttertoast.showToast(
          msg: "Please fill all the required credentials",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return;
      }

      try {
        // Show the loading animation
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
              child: SpinKitChasingDots(
                color: Colors.blue,
                size: 50.0,
              ),
            );
          },
        );

        final UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Hide the loading animation
        Navigator.pop(context);

        final User? user = userCredential.user;
        if (user != null) {
          if (user.emailVerified) {
            // Email is verified, navigate to the landing page
            Fluttertoast.showToast(
              msg: "Login Successful",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            Navigator.pushReplacementNamed(context, LandingPage.landingPage);
          } else {
            // Email is not verified, show an error message
            Fluttertoast.showToast(
              msg: "Email not verified! Please verify it.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        }
      } catch (e) {
        // Hide the loading animation
        Navigator.pop(context);

        // Authentication failed, show an error message
        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return AlertDialog(
        //       title: const Text("Authentication Error"),
        //       content: Text(e.toString()),
        //       actions: [
        //         TextButton(
        //           onPressed: () {
        //             Navigator.of(context).pop();
        //           },
        //           child: const Text("OK"),
        //         ),
        //       ],
        //     );
        //   },
        // );

        // Show toast for invalid credentials
        Fluttertoast.showToast(
          msg: "Invalid credentials. Please try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }

    return WillPopScope(
      onWillPop: () async {
        // Handle back button press
        final now = DateTime.now();
        const backButtonInterval =  Duration(seconds: 2);

        // If back button is pressed within 2 seconds of the last press, exit the app
        if (lastBackPressedTime == null ||
            now.difference(lastBackPressedTime!) > backButtonInterval) {
          lastBackPressedTime = now;
          Fluttertoast.showToast(
            msg: "Press again to exit",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return false;
        }

        return true;
      },
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue[200]!, Colors.blue[400]!],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Disaster Readiness Monitoring Application",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  const Text(
                    "Login to your App",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 36.0),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "User Email",
                      prefixIcon: const Icon(Icons.mail_rounded, color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18.0),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "User Password",
                      prefixIcon: const Icon(Icons.lock_rounded, color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  const Text(
                    "Forgot Password?",
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 44.0),
                  ElevatedButton(
                    onPressed: () {
                      _signInWithEmailAndPassword(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 8.0,
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Login"),
                  ),
                  const SizedBox(height: 12.0),
                  const SizedBox(height: 12.0),
                  Text.rich(
                    TextSpan(
                      text: "Don't have an Account? ",
                      children: [
                        TextSpan(
                          text: "Register Here",
                          style: const TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, RegisterPage.registerPage);
                            },
                        ),
                      ],
                    ),
                  ),
                  // Other form fields or widgets...
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

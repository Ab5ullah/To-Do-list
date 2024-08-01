import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_to_do_app/Forgot_password.dart';
import 'package:my_to_do_app/google_signin.dart';

import 'package:my_to_do_app/sign_up.dart';
import 'package:get/get.dart';
import 'package:my_to_do_app/auth_controller.dart';
import 'package:my_to_do_app/utils/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final GoogleSignInHandler googleSignInHandler = GoogleSignInHandler();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: w,
              height: h * 0.3,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("img/header.jpg"), fit: BoxFit.cover)),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              width: w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Hello",
                      style: TextStyle(
                          fontSize: 70,
                          fontWeight: FontWeight.bold,
                          color: AppColors.mainColor)),
                  const Text(
                    "Sign into your Account",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.smallTextColor),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 5,
                              offset: const Offset(1, 1),
                              color: Colors.grey.withOpacity(0.6))
                        ]),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                          hintText: "Email",
                          prefixIcon:
                              const Icon(Icons.email, color: Color(0xFF202e59)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.0)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.0)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30))),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 5,
                              offset: const Offset(1, 1),
                              color: Colors.grey.withOpacity(0.6))
                        ]),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon: const Icon(Icons.password_outlined,
                              color: Color(0xFF202e59)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.0)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.0)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30))),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      AuthController.instance.login(emailController.text.trim(),
                          passwordController.text.trim());
                    },
                    child: Center(
                      child: Container(
                        width: w * 0.5,
                        height: h * 0.07,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color:
                                const Color(0xFF202e59) // Set the desired color
                            ),
                        child: const Center(
                          child: Text(
                            "Sign in",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: w * 0.08,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "Forgot your password?",
                          style: TextStyle(
                            color: AppColors.textGrey,
                            fontSize: 14,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Get.to(
                                  () => const ForgetPassword(),
                                ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: w * 0.08,
                  ),
                  Center(
                    child: RichText(
                      text: TextSpan(
                          text: "Don't have an account? ",
                          style: const TextStyle(
                              color: AppColors.textGrey, fontSize: 15),
                          children: [
                            TextSpan(
                              text: "Create",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Get.to(
                                      () => const SignUpPage(),
                                    ),
                            ),
                          ]),
                    ),
                  ),
                  const Divider(thickness: 2),
                  Center(
                    child: RichText(
                      text: TextSpan(
                          text: "Sign-in via",
                          style:
                              TextStyle(fontSize: 15, color: Colors.grey[500])),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            googleSignInHandler.handleSignIn();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(
                                1), // Remove default padding
                            shape:
                                const CircleBorder(), // Make the button circular
                          ),
                          child: const ClipOval(
                            child: Image(
                              image: AssetImage("img/g.png"),
                              width: 40, // Set the desired width of the image
                              height: 40, // Set the desired height of the image
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      // Center(
                      //   child: ElevatedButton(
                      //     onPressed: () {
                      //       // Add your onPressed logic here
                      //     },
                      //     style: ElevatedButton.styleFrom(
                      //       padding:
                      //           EdgeInsets.all(1), // Remove default padding
                      //       shape: CircleBorder(), // Make the button circular
                      //     ),
                      //     child: ClipOval(
                      //       child: Image(
                      //         image: AssetImage("img/f.png"),
                      //         width: 40, // Set the desired width of the image
                      //         height: 40, // Set the desired height of the image
                      //         fit: BoxFit.cover,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Center(
                      //   child: ElevatedButton(
                      //     onPressed: () {
                      //       // Add your onPressed logic here
                      //     },
                      //     style: ElevatedButton.styleFrom(
                      //         padding:
                      //             EdgeInsets.all(1), // Remove default padding
                      //         shape: CircleBorder(),
                      //         backgroundColor:
                      //             Colors.white // Make the button circular
                      //         ),
                      //     child: ClipOval(
                      //       child: Image(
                      //         image: AssetImage("img/x.png"),
                      //         width: 40, // Set the desired width of the image
                      //         height: 40, // Set the desired height of the image
                      //         fit: BoxFit.cover,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:my_to_do_app/auth_controller.dart';
import 'package:my_to_do_app/google_signin.dart';
import 'package:my_to_do_app/utils/app_colors.dart';

var emailController = TextEditingController();
var passwordController = TextEditingController();
final GoogleSignInHandler googleSignInHandler = GoogleSignInHandler();

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

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
              padding: const EdgeInsets.only(left: 20, top: 60),
              alignment: Alignment.topLeft,
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height / 3.4,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("img/welcome.jpg"), fit: BoxFit.cover),
              ),
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.secondaryColor,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Let's Get Started",
              style: TextStyle(
                color: AppColors.smallTextColor,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            // const SizedBox(
            //   height: 30,
            // ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              width: w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      controller: emailController,
                      decoration: InputDecoration(
                          hintText: "Email",
                          prefixIcon: const Icon(Icons.email,
                              color: AppColors.mainColor),
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
                            color: AppColors.mainColor),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              const BorderSide(color: Colors.white, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                                color: Colors.white, width: 1.0)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      AuthController.instance.register(
                          emailController.text.trim(),
                          passwordController.text.trim());
                    },
                    child: Center(
                      child: Container(
                        width: w * 0.5,
                        height: h * 0.06,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 5,
                                  offset: const Offset(1, 1),
                                  color: Colors.grey.withOpacity(0.6))
                            ]),
                        child: const Center(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.mainColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: RichText(
                      text: TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Get.back(),
                          text: "Have an Account already?",
                          style:
                              TextStyle(fontSize: 15, color: Colors.grey[500])),
                    ),
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  const Divider(thickness: 2),
                  Center(
                    child: RichText(
                      text: TextSpan(
                          text: "Sign in using the following methods ",
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 15),
                          children: const []),
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
                      //       padding: const EdgeInsets.all(
                      //           1), // Remove default padding
                      //       shape:
                      //           const CircleBorder(), // Make the button circular
                      //     ),
                      //     child: const ClipOval(
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
                      //         padding: const EdgeInsets.all(
                      //             1), // Remove default padding
                      //         shape: const CircleBorder(),
                      //         backgroundColor:
                      //             Colors.white // Make the button circular
                      //         ),
                      //     child: const ClipOval(
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

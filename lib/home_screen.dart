// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:my_to_do_app/routes/routes.dart';
import 'add_task.dart';
import 'package:my_to_do_app/auth_controller.dart';
import 'package:my_to_do_app/utils/app_colors.dart';
import 'package:my_to_do_app/widgets/button_widget.dart';
import 'package:get/get.dart';

class home_screen extends StatefulWidget {
  String emails;
  home_screen({Key? key, required this.emails}) : super(key: key);

  @override
  State<home_screen> createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        padding: EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover, image: AssetImage("img/welcome.jpg"))),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: const TextSpan(
                  text: "Hello",
                  style: TextStyle(
                      color: AppColors.mainColor,
                      fontSize: 60,
                      fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: "\nStart Your Beautiful day",
                      style: TextStyle(
                        color: AppColors.smallTextColor,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                widget.emails,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mainColor,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 2.5),
              InkWell(
                onTap: () {
                  Get.to(() => AddTask(),
                      transition: Transition.fade,
                      duration: Duration(seconds: 1));
                },
                child: ButtonWidget(
                  backgroundcolor: AppColors.mainColor,
                  text: "Add Task",
                  textColor: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Get.toNamed(RoutesClass.getAllTasksRoute());
                },
                child: ButtonWidget(
                  backgroundcolor: Colors.white,
                  text: "View All",
                  textColor: AppColors.smallTextColor,
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  AuthController.instance.logout();
                },
                child: ButtonWidget(
                  backgroundcolor: AppColors.mainColor,
                  text: "Logout",
                  textColor: Colors.white,
                ),
              ),
            ]),
      ),
    );
  }
}

import 'package:get/get.dart';
import 'package:my_to_do_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class Message {
  static void taskErrorWarning(String taskName, String taskErrorWarning) {
    Get.snackbar(taskName, taskErrorWarning,
        backgroundColor: AppColors.smallTextColor,
        titleText: Text(taskName,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent)),
        messageText: Text(taskErrorWarning,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)));
  }
}

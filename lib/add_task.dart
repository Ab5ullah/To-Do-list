// ignore_for_file: no_leading_underscores_for_local_identifiers, non_constant_identifier_names

import 'dart:io';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_to_do_app/all_task.dart';
import 'package:my_to_do_app/error_msg.dart';
import 'package:my_to_do_app/utils/app_colors.dart';
import 'package:my_to_do_app/widgets/button_widget.dart';
import 'package:my_to_do_app/widgets/textfield_widget.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController namecontroller = TextEditingController();

  TextEditingController detailcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    DateTime dateTime = DateTime.now();
    String imageURL = '';

    double h = MediaQuery.of(context).size.height;
    bool _dataValidation() {
      if (namecontroller.text.trim() == '') {
        Message.taskErrorWarning('Task Name', 'Your Task Name is Empty');
        return false;
      } else if (detailcontroller.text.trim() == '') {
        Message.taskErrorWarning("Task Detail", "Task Detail is Empty");
        return false;
      } else if (imageURL == '') {
        Message.taskErrorWarning("Image", 'Warning: No image selected');
      }
      return true;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: w,
                  height: h * 0.3,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("img/header.jpg"),
                          fit: BoxFit.cover)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          Icons.arrow_back,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                      const SizedBox(height: 10)
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                  'Creating on: ${DateFormat('dd MMM yyyy, hh:mm a').format(dateTime)}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  )),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              width: w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: TextFieldWidget(
                        textController: namecontroller,
                        hintText: "Task Name",
                        readonly: false,
                        borderRadius: 25,
                        maxLines: 1),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: TextFieldWidget(
                        textController: detailcontroller,
                        hintText: "Task Details",
                        readonly: false,
                        borderRadius: 20,
                        maxLines: 4),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.textGrey,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () async {
                            ImagePicker imagePicker = ImagePicker();
                            XFile? file = await imagePicker.pickImage(
                                source: ImageSource.camera);
                            print('${file?.path}');
                            if (file == null) return;
                            //unique file name
                            String uniqueFilename = DateTime.now()
                                .microsecondsSinceEpoch
                                .toString();
                            //Get reference to storage root
                            Reference referenceRoot =
                                FirebaseStorage.instance.ref();
                            Reference referenceDirImages =
                                FirebaseStorage.instance.ref().child('images');
                            //create a reference for the image to be stored
                            Reference referenceImageToUpload =
                                referenceDirImages.child(uniqueFilename);
                            try {
                              //store the file
                              await referenceImageToUpload
                                  .putFile(File(file.path));
                              imageURL =
                                  await referenceImageToUpload.getDownloadURL();
                            } catch (error) {}
                          },
                          child: Row(
                            children: [
                              Icon(Icons.camera_alt,
                                  color:
                                      Colors.black), // Set icon color to black
                              SizedBox(width: 8),
                              Text(
                                'Add Image',
                                style: TextStyle(
                                    color: Colors
                                        .black), // Set text color to black
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      bool isValid = _dataValidation();

                      if (isValid) {
                        String taskName = namecontroller.text;
                        String taskDetails = detailcontroller.text;

                        // Call the function to send data to Firestore.
                        sendDataToFirestore(taskName, taskDetails, imageURL);

                        // Clear the text fields.
                        namecontroller.clear();
                        detailcontroller.clear();
                        Get.to(() => const AllTask(),
                            transition: Transition.circularReveal);
                      }
                    },
                    child: Container(
                      width: w * 1,
                      height: h * 0.07,
                      child: ButtonWidget(
                        backgroundcolor: AppColors.mainColor,
                        text: "Add",
                        textColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void sendDataToFirestore(String taskName, String taskDetails, String image) {
    try {
      final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

      // Create a TaskModel instance with empty taskId (to be set by Firestore).
      if (currentUserUid != null) {
        TaskModel taskModel = TaskModel(
          taskId: '',
          taskName: taskName,
          description: taskDetails,
          dateTime: DateTime.now(),
          ImageUrl: image,
        );

        // Send the task data to Firestore and get the generated document ID.
        DocumentReference docRef =
            FirebaseFirestore.instance.collection('tasks2').doc();
        taskModel.taskId = docRef.id; // Set the generated document ID.

        // Convert the taskModel to a Map to save it in Firestore.
        Map<String, dynamic> taskData = {
          'task': taskModel.taskName,
          'description': taskModel.description,
          'dateTime': taskModel.dateTime,
          'ownerUid': currentUserUid,
          'images': taskModel.ImageUrl,
        };

        // Save the data in Firestore using the document ID.
        docRef.set(taskData).then((_) {
          // Data sent successfully.
          print('Data sent to Firestore!');
        }).catchError((error) {
          // Handle any errors that occur during data submission.
          print('Error sending data to Firestore: $error');
        });
      }
      ;
    } catch (error) {
      print('Error sending data to Firestore: $error');
    }
  }
}

class TaskModel {
  late String taskId;
  final String taskName;
  final String description;
  final DateTime dateTime;
  final String ImageUrl;

  TaskModel({
    required this.taskId,
    required this.taskName,
    required this.description,
    required this.dateTime,
    required this.ImageUrl,
  });
}

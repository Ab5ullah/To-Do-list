import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:flutter/src/widgets/framework.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_to_do_app/all_task.dart';
import 'package:my_to_do_app/error_msg.dart';
import 'package:my_to_do_app/utils/app_colors.dart';
import 'package:my_to_do_app/widgets/button_widget.dart';
import 'package:my_to_do_app/widgets/textfield_widget.dart';

class EditTask extends StatefulWidget {
  final String taskId; // Receive taskId as a parameter.

  const EditTask({required this.taskId, Key? key}) : super(key: key);

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController detailcontroller = TextEditingController();
  bool isLoading = false;
  String ImageUrl = '';

  final imageContainerHeight = 350.0;
  final imageContainerWidth = 400.0;
  @override
  void initState() {
    super.initState();
    // Fetch task data using the taskId when the widget is initialized.
    fetchTaskDataFromFirestore(widget.taskId);
  }

  Future<void> fetchTaskDataFromFirestore(String taskId) async {
    try {
      setState(() {
        isLoading = true;
      });

      // Use the received task ID (taskId) to fetch the specific task data from Firestore.
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('tasks2')
          .doc(taskId)
          .get();

      if (snapshot.exists) {
        // Access the data inside the document using the 'data()' method
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        // Set the fetched data to the text controllers
        namecontroller.text = data['task'];
        detailcontroller.text = data['description'];
        ImageUrl = data['images'] ?? '';
      } else {
        // Document does not exist in Firestore.
        print('Document does not exist in Firestore.');
      }
    } catch (error) {
      // Handle any errors that occur during data retrieval.
      print('Error fetching data from Firestore: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    bool _dataValidation() {
      if (namecontroller.text.trim() == '') {
        Message.taskErrorWarning('Task Name', 'Your Task Name is Empty');
        return false;
      } else if (detailcontroller.text.trim() == '') {
        Message.taskErrorWarning("Task Detail", "Task Detail is Empty");
        return false;
      }
      return true;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: w,
                  height: h * 0.3,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
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
                        constraints: BoxConstraints(),
                        icon: Icon(
                          Icons.arrow_back,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                      SizedBox(height: 10)
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              width: w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: TextFieldWidget(
                        textController: namecontroller,
                        hintText: "Task Name",
                        readonly: false,
                        borderRadius: 30,
                        maxLines: 3),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: TextFieldWidget(
                        textController: detailcontroller,
                        hintText: "Task Details",
                        readonly: false,
                        borderRadius: 30,
                        maxLines: 3),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: imageContainerHeight,
                    width: imageContainerWidth,
                    child: ImageUrl.isNotEmpty
                        ? Image.network(ImageUrl)
                        : Container(),
                  ),
                  SizedBox(
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
                                source: ImageSource.gallery);
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
                              ImageUrl =
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
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      bool isValid = _dataValidation();

                      if (isValid) {
                        String taskName = namecontroller.text;
                        String taskDetails = detailcontroller.text;

                        // Call the function to send data to Firestore.
                        updateDataInFirestore(
                            widget.taskId, taskName, taskDetails, ImageUrl);

                        // Clear the text fields.
                        namecontroller.clear();
                        detailcontroller.clear();
                        Get.to(() => AllTask(),
                            transition: Transition.circularReveal);
                      }
                    },
                    child: Container(
                      width: w * 1,
                      height: h * 0.07,
                      child: ButtonWidget(
                        backgroundcolor: AppColors.mainColor,
                        text: "Update",
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

  void updateDataInFirestore(
      String taskId, String taskName, String taskDetails, String image) {
    try {
      setState(() {
        isLoading = true;
      });

      // Update the task data in Firestore
      FirebaseFirestore.instance.collection('tasks2').doc(taskId).update({
        'task': taskName,
        'description': taskDetails,
        'images': ImageUrl,
      }).then((_) {
        // Data updated successfully.
        print('Data updated in Firestore!');
        Get.to(() => AllTask(), transition: Transition.circularReveal);
      }).catchError((error) {
        // Handle any errors that occur during data update.
        print('Error updating data to Firestore: $error');
      });
    } catch (error) {
      print('Error updating data to Firestore: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}

class TaskModel {
  late String taskId;
  final String taskName;
  final String description;

  TaskModel({
    required this.taskId,
    required this.taskName,
    required this.description,
  });
}

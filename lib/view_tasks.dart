// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_to_do_app/utils/app_colors.dart';
import 'package:my_to_do_app/widgets/textfield_widget.dart';

class ViewTask extends StatefulWidget {
  final String taskId; // Receive taskId as a parameter.

  const ViewTask({required this.taskId, Key? key}) : super(key: key);

  @override
  State<ViewTask> createState() => _ViewTaskState();
}

class _ViewTaskState extends State<ViewTask> {
  String taskName = '';
  String taskDetails = '';
  DateTime dateTime = DateTime.now();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController detailcontroller = TextEditingController();
  String ImageUrl = '';

  @override
  void initState() {
    super.initState();
    // Fetch task data using the taskId when the widget is initialized.
    fetchTaskDataFromFirestore(widget.taskId);
  }

  Future<void> fetchTaskDataFromFirestore(String taskId) async {
    try {
      // Use the received task ID (taskId) to fetch the specific task data from Firestore.
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('tasks2')
          .doc(taskId)
          .get();

      if (snapshot.exists) {
        // Access the data inside the document using the 'data()' method
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        // Set the fetched data to the variables
        setState(() {
          taskName = data['task'];
          taskDetails = data['description'];
          dateTime = data['dateTime'].toDate();
          ImageUrl =
              data['images'] ?? ''; // Fetch the image URL from data['images']
        });
      } else {
        // Document does not exist in Firestore.
        print('Document does not exist in Firestore.');
      }
    } catch (error) {
      // Handle any errors that occur during data retrieval.
      print('Error fetching data from Firestore: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    const imageContainerHeight = 350.0;
    const imageContainerWidth = 400.0;
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
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                      const SizedBox(height: 0),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Created on: ${DateFormat('dd MMM yyyy, hh:mm a').format(dateTime)}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ), // Display the date and time here

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  TextFieldWidget(
                      textController: TextEditingController(text: taskName),
                      hintText: "Task Name",
                      readonly: true, //get data from firebase
                      borderRadius: 30,
                      maxLines: 1),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFieldWidget(
                      textController: TextEditingController(text: taskDetails),
                      hintText:
                          "Task Details", //get data from firebase in this hint text.
                      borderRadius: 30,
                      readonly: true,
                      maxLines: 3),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: imageContainerHeight,
                    width: imageContainerWidth,
                    child: ImageUrl.isNotEmpty
                        ? Image.network(ImageUrl)
                        : Container(),
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

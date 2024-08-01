import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

import 'package:my_to_do_app/edit_task.dart';

import 'package:my_to_do_app/utils/app_colors.dart';
import 'package:my_to_do_app/view_tasks.dart';
import 'package:my_to_do_app/widgets/button_widget.dart';
import 'package:get/get.dart';
import '../widgets/task_widget.dart';
import 'add_task.dart';

class AllTask extends StatefulWidget {
  const AllTask({super.key});

  @override
  State<AllTask> createState() => _AllTaskState();
}

class _AllTaskState extends State<AllTask> {
  int _totalCount = 0;
  final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

  StreamSubscription<QuerySnapshot>? _streamSubscription;

  @override
  void initState() {
    super.initState();
    _subscribeToDataChanges();
  }

  @override
  void dispose() {
    _unsubscribeFromDataChanges();
    super.dispose();
  }

  void _subscribeToDataChanges() {
    _streamSubscription = FirebaseFirestore.instance
        .collection('tasks2')
        .where('ownerUid', isEqualTo: currentUserUid)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _totalCount = snapshot.docs.length;
      });
    });
  }

  void _unsubscribeFromDataChanges() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }

  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('dd MMM yyyy').format(DateTime.now());
    final leftEditIcon = Container(
      margin: EdgeInsets.only(bottom: 10),
      color: Color(0xFF2e3253).withOpacity(0.5),
      alignment: Alignment.centerLeft,
      child: Icon(
        Icons.edit,
        color: Colors.white,
      ),
    );

    final rightEditIcon = Container(
      margin: EdgeInsets.only(bottom: 10),
      color: Colors.redAccent,
      alignment: Alignment.centerRight,
      child: Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, top: 60),
            alignment: Alignment.topLeft,
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height / 3.2,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("img/header1.jpg"),
              ),
            ),
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.arrow_back,
                color: AppColors.secondaryColor,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                Text(
                  'Total Count: $_totalCount',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.secondaryColor,
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () => Get.to(() => AddTask()),
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.5),
                        color: Colors.black),
                    child: Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Icon(
                  Icons.calendar_today,
                  color: AppColors.mainColor,
                ),
                SizedBox(width: 10),
                Text(
                  currentDate, // Display today's date here
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.secondaryColor,
                  ),
                )
              ],
            ),
          ),
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('tasks2')
                    .where('ownerUid', isEqualTo: currentUserUid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error fetching data'),
                    );
                  }

                  final List<QueryDocumentSnapshot> documents =
                      snapshot.data!.docs;

                  return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        final taskName = documents[index]['task'] ?? '';
                        //    final taskDetails =
                        //      documents[index]['description'] ?? '';

                        return Dismissible(
                          key: ObjectKey(documents[index]
                              .id), // Use a unique key for each item

                          background: leftEditIcon,
                          secondaryBackground: rightEditIcon,
                          onDismissed: (DismissDirection direction) {
                            print("After Dismiss");
                          },
                          confirmDismiss: (DismissDirection direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  barrierColor: Colors.transparent,
                                  context: context,
                                  builder: (_) {
                                    return Container(
                                        height: 200,
                                        decoration: BoxDecoration(
                                            color: Color(0xFF2e3253)
                                                .withOpacity(0.4),
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20))),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 17, right: 17),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  // Use the fetched taskId from the snapshot.
                                                  String taskId =
                                                      documents[index].id;

                                                  // Navigate to the ViewTask screen and pass the taskId as a parameter.
                                                  Get.to(
                                                      () => ViewTask(
                                                          taskId: taskId),
                                                      transition: Transition
                                                          .circularReveal);
                                                },
                                                child: ButtonWidget(
                                                  backgroundcolor:
                                                      AppColors.mainColor,
                                                  text: "View",
                                                  textColor: Colors.white,
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              GestureDetector(
                                                onTap: () {
                                                  // Use the fetched taskId from the snapshot.
                                                  String taskId =
                                                      documents[index].id;

                                                  // Navigate to the ViewTask screen and pass the taskId as a parameter.
                                                  Get.to(
                                                      () => EditTask(
                                                          taskId: taskId),
                                                      transition: Transition
                                                          .circularReveal);
                                                },
                                                child: ButtonWidget(
                                                  backgroundcolor:
                                                      AppColors.mainColor,
                                                  text: "Edit",
                                                  textColor: Colors.white,
                                                ),
                                              )
                                            ],
                                          ),
                                        ));
                                  });
                              return false;
                            } else {
                              bool isDeleteConfirmed = await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Delete Task'),
                                  content: Text(
                                      'Are you sure you want to delete this task?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context,
                                            false); // User didn't confirm delete.
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context,
                                            true); // User confirmed delete.
                                      },
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                              );

                              if (isDeleteConfirmed == true) {
                                // Use the fetched taskId from the snapshot.
                                String taskId = documents[index].id;

                                // Call the function to delete the task from Firestore.
                                await _deleteTaskFromFirestore(taskId);

                                // After the task is deleted, refresh the list to reflect the changes.
                                setState(() {
                                  documents.removeAt(index);
                                });
                              }

                              return false; // Delayed dismissal, so return false here as well.
                            }
                          },
                          //    key: ObjectKey(index),
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 20, right: 20, bottom: 10),
                            child: TaskWidget(
                              text: taskName,
                              color: Colors.blueGrey,
                            ),
                          ),
                        );
                      });
                }),
          )
        ],
      ),
    );
  }
}

Future<void> _deleteTaskFromFirestore(String taskId) async {
  try {
    // Use the received task ID (taskId) to reference the specific task document in Firestore.
    await FirebaseFirestore.instance.collection('tasks2').doc(taskId).delete();
    // Perform any additional actions after successful deletion, if needed.

    // Now you can navigate back to the previous screen after the deletion is successful.
  } catch (error) {
    // Handle any errors that occur during deletion.
    print('Error deleting task from Firestore: $error');
  }
}

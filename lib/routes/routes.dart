import 'package:get/get.dart';
import 'package:my_to_do_app/add_task.dart';
import 'package:my_to_do_app/all_task.dart';
import 'package:my_to_do_app/home_screen.dart';

class RoutesClass {
  static String home = "/";
  static String allTask = "/allTask";
  static String addTask = "/addTask";

  static String getHomeRoute() => home;
  static String getAllTasksRoute() => allTask;
  static String getAddTasksRoute() => addTask;

  static List<GetPage> routes = [
    GetPage(
        page: () => home_screen(
              emails: '',
            ),
        name: home),
    GetPage(
        page: () => const AllTask(),
        name: allTask,
        transition: Transition.fade,
        transitionDuration: const Duration(seconds: 1)),
    GetPage(
        page: () => const AddTask(),
        name: addTask,
        transition: Transition.zoom,
        transitionDuration: const Duration(milliseconds: 500)),
  ];
}

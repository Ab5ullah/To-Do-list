import 'package:flutter/material.dart';

class TaskWidget extends StatelessWidget {
  final String text;
  final Color color;

  const TaskWidget({
    Key? key,
    required this.text,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: MediaQuery.of(context).size.height / 13,
      decoration: BoxDecoration(
          color: const Color(0xffedff0f8),
          borderRadius: BorderRadius.circular(0)),
      child: Center(
          child: Text(text, style: TextStyle(fontSize: 20, color: color))),
    );
  }
}

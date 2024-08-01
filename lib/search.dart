import 'package:flutter/material.dart';

class TaskSearchBar extends StatelessWidget {
  final TextEditingController searchController;

  const TaskSearchBar({super.key, required this.searchController});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Color(0xFFF2F2F2),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              searchController.clear();
            },
          ),
        ],
      ),
    );
  }
}

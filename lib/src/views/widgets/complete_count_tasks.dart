// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/models/plan/plan_export.dart';

class CompleteCountTasks extends StatelessWidget {
  TasksList tasksList;

  CompleteCountTasks({
    Key? key,
    required this.tasksList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
        '${tasksList.completeCountTask} ${Language.instance.Out_Of} ${tasksList.tasks.length}');
  }
}

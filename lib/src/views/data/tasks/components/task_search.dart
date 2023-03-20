import 'package:flutter/material.dart';
import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/controllers/settings/themes.dart';
import 'package:todoon/src/models/plan/plan_export.dart';
import 'package:todoon/src/routes/routes.dart';
import 'package:todoon/src/views/data/tasks/task_edit_page.dart';

/// Task search delegate.
class TaskSearchDelegate extends SearchDelegate {
  final Plan plan;
  final TasksList taskList;

  TaskSearchDelegate(
    this.plan,
    this.taskList,
  ) : super(
          searchFieldLabel: Language.instance.Search,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          tooltip: Language.instance.Refresh,
          icon: const Icon(Icons.replay))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        tooltip: Language.instance.Back,
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Task> matchQuery = [];
    for (var task in taskList.tasks) {
      if (task.description.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(task);
      }
    }
    return ListView.builder(
      itemBuilder: (context, index) {
        var task = matchQuery[index];
        return ListTile(
          leading: CircleAvatar(
              backgroundColor:
                  Themes.instance.DrawerItemCompleteContentColor(task.complete),
              child: Text(plan.name[0])),
          title: Text(task.description,
              style: Themes.instance.DrawerItemContentTextStyle(task.complete)),
          onTap: () => Navigator.pushNamed(context, TaskEditPage.routeName,
              arguments: TaskPageArguments(plan, task)),
        );
      },
      itemCount: matchQuery.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Task> matchQuery = [];

    for (var task in taskList.tasks) {
      if (task.description.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(task);
      }
    }

    return ListView.builder(
      itemBuilder: (context, index) {
        var task = matchQuery[index];
        return ListTile(
          leading: CircleAvatar(
              backgroundColor:
                  Themes.instance.DrawerItemCompleteContentColor(task.complete),
              child: Text(plan.name[0])),
          title: Text(task.description,
              style: Themes.instance.DrawerItemContentTextStyle(task.complete)),
          onTap: () => Navigator.pushNamed(context, TaskEditPage.routeName,
              arguments: TaskPageArguments(plan, task)),
        );
      },
      itemCount: matchQuery.length,
    );
  }
//end code
}

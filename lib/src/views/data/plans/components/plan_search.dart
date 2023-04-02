import 'package:flutter/material.dart';
import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/constants/themes/todoon_icons.dart';
import 'package:todoon/src/models/plan/plan_export.dart';
import 'package:todoon/src/views/data/tasks/pages/tasks_page.dart';

/// Plan search delegate.
class PlanSearchDelegate extends SearchDelegate {
  final PlansList plansList;

  PlanSearchDelegate(this.plansList)
      : super(
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
          icon: const Icon(ToDoonIcons.refresh))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        tooltip: Language.instance.Back,
        icon: const Icon(ToDoonIcons.back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Plan> matchQuery = [];
    for (var plan in plansList.plans) {
      if (plan.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(plan);
      }
    }
    return ListView.builder(
      itemBuilder: (context, index) {
        var plan = matchQuery[index];
        return ListTile(
          leading: CircleAvatar(child: Text(plan.name[0])),
          title: Text(plan.name),
          onTap: () => Navigator.pushNamed(context, TasksPage.routeName,
              arguments: plan),
        );
      },
      itemCount: matchQuery.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Plan> matchQuery = [];

    for (var plan in plansList.plans) {
      if (plan.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(plan);
      }
    }

    return ListView.builder(
      itemBuilder: (context, index) {
        var plan = matchQuery[index];
        return ListTile(
          leading: CircleAvatar(child: Text(plan.name[0])),
          title: Text(plan.name),
          onTap: () => Navigator.pushNamed(context, TasksPage.routeName,
              arguments: plan),
        );
      },
      itemCount: matchQuery.length,
    );
  }
//end code
}

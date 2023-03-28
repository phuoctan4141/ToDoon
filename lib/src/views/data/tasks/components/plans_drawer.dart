// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';

import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/controllers/settings/themes.dart';
import 'package:todoon/src/views/data/tasks/pages/tasks_page.dart';
import 'package:todoon/src/models/plan/plan_export.dart';

class PlansDrawer extends StatelessWidget {
  List<Plan> plans;
  Plan plan;
  ScrollController scrollController;

  PlansDrawer({
    Key? key,
    required this.plans,
    required this.plan,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      // ignore: prefer_const_literals_to_create_immutables
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(Icons.assignment_outlined,
              color: Themes.instance.RadioSelectedColor),
          title: Text(Language.instance.Plans,
              // ignore: prefer_const_constructors
              style: Themes.instance.DrawerTitleContentTextStyle),
        ),
        const Divider(),
        ListView.builder(
            padding: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            shrinkWrap: true,
            controller: scrollController,
            itemCount: plans.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(child: Text(plan.name[0])),
                title: Text(plans[index].name),
                onTap: () {
                  if (plans[index].id != plan.id) {
                    Navigator.popAndPushNamed(context, TasksPage.routeName,
                        arguments: plans[index]);
                  }
                },
              );
            }),
      ],
    );
  }
}

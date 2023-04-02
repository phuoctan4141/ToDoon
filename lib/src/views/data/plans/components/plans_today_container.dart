// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/constants/themes/todoon_icons.dart';

class PlansTodayContainer extends StatelessWidget {
  Function()? onTap;
  PlansTodayContainer({
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.inversePrimary,
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              spreadRadius: 1,
              blurStyle: BlurStyle.normal,
              color:
                  Theme.of(context).colorScheme.inverseSurface.withOpacity(0.5),
            ),
          ],
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.inversePrimary,
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5),
              ]),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Lottie.asset(ToDoonIcons.today_lottie,
                    width: 60.0, height: 60.0),
                Text(
                  context.watch<Language>().Focus_Content,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NoTasksToday extends StatelessWidget {
  const NoTasksToday({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width / 3,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(ToDoonIcons.no_task_lottie, height: 60, width: 60),
              Text(
                context.watch<Language>().No_Tasks,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          )),
    );
  }
}

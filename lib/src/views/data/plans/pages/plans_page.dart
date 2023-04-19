// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/constants/states.dart';
import 'package:todoon/src/constants/strings.dart';
import 'package:todoon/src/constants/themes/todoon_icons.dart';
import 'package:todoon/src/controllers/data/data_controller.dart';
import 'package:todoon/src/routes/routes_export.dart';
import 'package:todoon/src/views/data/plans/components/plans_components.dart';
import 'package:todoon/src/views/widgets/allow_notices_widget.dart';
import 'package:todoon/src/views/widgets/drawer_widget.dart';
import 'package:todoon/src/views/widgets/empty_icon_widget.dart';
import 'package:todoon/src/views/widgets/wrong_widget.dart';

class PlansPage extends StatefulWidget {
  static const routeName = PAGE_HOME;
  // ignore: prefer_const_constructors_in_immutables
  PlansPage({super.key});

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> with TickerProviderStateMixin {
  late ScrollController scrollController;
  late TextEditingController planController;

  AnimationController? animationController;
  late AnimationController pieController;

  late PlansList plansList = PlansList(plans: []);
  late PlansList plansListToday = PlansList(plans: []);
  late bool isLoading = true;

  //NativeAd? _nativeAd;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
    planController = TextEditingController();
    fetandhandleData(context);
    AllowNoticesWidget(context);

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    animationController!.forward();
  }

  @override
  void dispose() {
    scrollController.dispose();
    planController.dispose();
    animationController?.dispose();
    //_nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataController>(
      builder: (context, dataController, child) {
        plansList = dataController.getData;
        plansListToday = dataController.getDataToday;

        dataController.addListener(() {
          animationController?.reset();
          animationController?.forward();
        });

        return Scaffold(
          appBar: AppBar(
            title: const Text(Strings.NAME_APP,
                style: TextStyle(fontWeight: FontWeight.bold)),
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(ToDoonIcons.drawer),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  tooltip: Language.instance.Show_Menu,
                );
              },
            ),
            actions: [
              _search(context, plansList),
            ],
          ),
          // ignore: prefer_const_constructors
          drawer: DrawerWidget(
            notHome: false,
          ),
          body: _bodyPlans(context, plansList),
          floatingActionButton: _floatingActionButton(context),
        );
      },
    );
  }

  /////////////////////////////
  // View Widgets  ////////////
  // View Widgets /////////////
  /////////////////////////////

  Widget _search(BuildContext context, PlansList plansList) {
    return IconButton(
        onPressed: () {
          showSearch(context: context, delegate: PlanSearchDelegate(plansList));
        },
        tooltip: Language.instance.Search,
        icon: const Icon(ToDoonIcons.search));
  }

  // Load data from _inMemoryCache.
  Widget _bodyPlans(BuildContext context, PlansList plansList) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Center(
        child: plansList.plans.isEmpty
            // ignore: prefer_const_constructors
            ? EmptyIconWidget()
            : Column(
                children: [
                  SafeArea(child: _buildPlansToday(context)),
                  Expanded(child: _buildPlansList(context, plansList)),
                ],
              ),
      );
    }
  }

  Widget _buildPlansToday(BuildContext context) {
    return _buildPlansTodayContainer(context);
  }

  Widget _buildPlansTodayContainer(BuildContext context) {
    final plansToday = plansListToday.plans;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SafeArea(
            child: plansToday.isNotEmpty
                ? PlansTodayContainer(
                    onTap: () => _routePlansToday(context),
                  )
                : const NoTasksToday(),
          ),
          //_adsContainer(context),
          Expanded(child: _doWorkContainer(context)),
        ],
      ),
    );
  }

  Widget _doWorkContainer(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => Navigator.pushNamed(context, IntroPage.routeName),
      child: Card(
        elevation: 3.0,
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(8.0),
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          width: (MediaQuery.of(context).size.width * (2 / 3)),
          child: Lottie.asset(
            ToDoonIcons.do_work_lottie,
            controller: animationController,
          ),
        ),
      ),
    );
  }

  Widget _adsContainer(BuildContext context) {
    //_nativeAd = AdsHelper.instance.getNativeAd;
    if (Platform.isAndroid) {
      return Card(
        child: Container(
          margin: const EdgeInsets.all(8.0),
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          width: (MediaQuery.of(context).size.width * (2 / 3) - 40),
          child: Container(
            alignment: Alignment.center,
            height: 104,
            width: (MediaQuery.of(context).size.width * (2 / 3) - 56),
            child: Container(),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildPlansList(BuildContext context, PlansList plansList) {
    return ListView.builder(
        clipBehavior: Clip.antiAlias,
        controller: scrollController,
        shrinkWrap: true,
        itemCount: plansList.plans.length,
        itemBuilder: (context, indexPlan) =>
            _buildPlanTile(context, plansList.plans, indexPlan));
  }

  Widget _buildPlanTile(BuildContext context, List<Plan> plans, int indexPlan) {
    final plan = plans[indexPlan];

    return PlanTitle(
      plan: plan,
      onDismissed: (_) async => dismissPlan(context, plan),
      onTap: () {
        _routePlan(context, plan);
      },
      trailing: _menuPlan(context, plan),
    );
  }

  Widget _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await addNewPlan(context);
      },
      tooltip: Language.instance.Add_Plan,
      child: const Icon(ToDoonIcons.add_plan),
    );
  }

  Widget _menuPlan(BuildContext context, Plan plan) {
    return MenuPlan(
        onEdit: () => editPlan(context, plan),
        onDelete: () => deletePlan(context, plan));
  }

  // ignore: unused_element
  Widget _confirmDelete(BuildContext context) {
    return const AlertDeletePlan();
  }

  /////////////////////////////
  // View handle  /////////////
  // View handle //////////////
  /////////////////////////////

  void _routePlan(BuildContext context, Plan plan) {
    Navigator.pushNamed(context, TasksPage.routeName, arguments: plan);
  }

  void _routePlansToday(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
        context, PlansTodayPage.routeName, ModalRoute.withName(PAGE_HOME));
  }

  Future<void> fetandhandleData(BuildContext context) async {
    final done = await context.read<DataController>().loadData;

    if (done.compareTo(States.TRUE) == 0) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addNewPlan(BuildContext context) async {
    planController = TextEditingController();
    final dataController = context.read<DataController>();

    await showDialog(
      context: context,
      builder: (BuildContext context) => AddPLan(
          controller: planController,
          onAdd: () async {
            final name = planController.text;
            final done = await dataController.doAddNewPlan(name);

            if (context.mounted) {
              if (done.compareTo(States.TRUE) == 0) {
                Navigator.of(context).pop(true);
              } else {
                Navigator.of(context).pop(false);
                wrongWidget(context);
              }
            }
          },
          onCancel: () => Navigator.of(context).pop(false)),
    );
  }

  Future<void> editPlan(BuildContext context, Plan plan) async {
    final dataController = context.read<DataController>();
    planController = TextEditingController();
    planController.text = plan.name;

    await showDialog(
      context: context,
      builder: (BuildContext context) => EditPlan(
          controller: planController,
          onEdit: () async {
            final name = planController.text;
            final done = await dataController.doEditPlan(plan, name);

            if (context.mounted) {
              if (done.compareTo(States.TRUE) == 0) {
                Navigator.of(context).pop(true);
              } else {
                Navigator.of(context).pop(false);
                wrongWidget(context);
              }
            }
          },
          onCancel: () => Navigator.of(context).pop(false)),
    );
  }

  Future<void> dismissPlan(BuildContext context, Plan plan) async {
    final dataController = context.read<DataController>();
    final done = await dataController.doDeletePlan(plan);

    if (context.mounted && done.compareTo(States.TRUE) == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${plan.name} ${Language.instance.Plan_Dismissed}'),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 1),
      ));
    }
  }

  Future<void> deletePlan(BuildContext context, Plan plan) async {
    final dataController = context.read<DataController>();

    final isConfirmDelete = await showDialog(
        context: context,
        builder: (BuildContext context) => _confirmDelete(context));

    if (isConfirmDelete ?? false) {
      final done = await dataController.doDeletePlan(plan);

      if (context.mounted && done.compareTo(States.TRUE) == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${Language.instance.Delete_Plan} ${plan.name}'),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(10),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    }
  }
//end code
}
